# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ValidatableFile do
  shared_examples 'a validatable file' do
    describe 'validations' do
      subject { model.class.new }

      it { is_expected.to validate_presence_of(:url) }
      it { is_expected.to validate_inclusion_of(:size).in_range(model.class.content_length_range) }
      it { is_expected.to validate_presence_of(:content_type) }

      context 'when filename is blank' do
        it 'shows an error message' do
          model.url_path = blank_filename

          model.validate

          expect(model.errors.full_messages.first).to eq(blank_message_for_url_path)
        end
      end
    end

    describe '#sanitize_attrs' do
      context 'when filename has malicious input' do
        it 'transforms malicious input into safe output' do
          model.url_path = malicious_input

          model.validate

          expect(model.url_path).to match(/\"&gt;/)
        end
      end

      context 'when filename has no malicious input' do
        it 'does not transform input' do
          url = model.url

          model.validate

          expect(model.url).to eq(url)
        end
      end

      context 'when filename is empty' do
        it 'does nothing' do
          model.url_path = ''

          model.validate

          expect(model.url_path).to be_blank
        end
      end
    end

    describe '#ensure_content_type_correct' do
      context 'when content-type is blank' do
        it 'sets correct content-type looking by filename' do
          content_type = model.content_type
          model.content_type = nil

          model.validate

          expect(model.content_type).to eq(content_type)
        end
      end

      context 'when content-type and filename are blank' do
        it 'returns empty string' do
          model.content_type = nil
          model.url_path = ''

          model.validate

          expect(model.content_type).to be_blank
        end
      end

      # user could modify content-type data on the client-side
      # https://github.com/rokumatsumoto/boyutluseyler/blob/f508152626a416d35b8dbb9b12a2de4195e737d5/app/javascript/connected_uploader/store/actions.js#L43
      # and this data could reach us from direct upload provider
      # https://github.com/rokumatsumoto/boyutluseyler/blob/f508152626a416d35b8dbb9b12a2de4195e737d5/app/services/blueprints/build_service.rb#L12
      context 'when content-type is not allowed' do
        it 'sets correct content-type looking by filename' do
          model.content_type = malicious_input

          model.validate

          expect(model.content_type).not_to eq(malicious_input)
        end
      end

      context 'when content-type is allowed' do
        it 'does not set content-type' do
          allow(model).to receive(:content_type_by_filename)

          model.validate

          expect(model).not_to have_received(:content_type_by_filename)
        end
      end
    end
  end

  context 'when model is a Blueprint' do
    it_behaves_like 'a validatable file' do
      let(:model) { build_stubbed(:blueprint) }
      let(:blank_filename) { '.stl' }
      let(:malicious_input) { '"><svg onload=alert(1)>.stl' }
    end
  end

  context 'when model is an Illustration' do
    it_behaves_like 'a validatable file' do
      let(:model) { build_stubbed(:illustration) }
      let(:blank_filename) { '.jpg' }
      let(:malicious_input) { '"><svg onload=alert(1)>.jpg' }
    end
  end

  def blank_message_for_url_path
    t('activerecord.errors.models.blueprint.attributes.url_path.blank')
  end
end
