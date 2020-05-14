# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Blueprints::BuildService do
  describe 'modules' do
    it { is_expected.to include_module(ValidatesRemoteObject) }
  end

  describe '#execute' do
    subject(:service) { described_class.new(user, params) }

    let(:user) { build_stubbed(:user) }
    let(:params) { { key: 'model.stl' } }
    let(:validation_error) { described_class::ValidationError }

    context 'when the remote object is not exist' do
      before do
        stub_direct_upload_bucket_object_is_not_exist
      end

      after do
        stub_direct_upload_bucket_object_exists # default stub behavior
      end

      it 'raises a file not found error' do
        expect { service.execute }.to raise_error(validation_error, 'File not found')
      end
    end

    context 'when the remote object exists' do
      it 'builds a blueprint without saving it' do
        # rubocop:disable RSpec/VerifiedDoubles
        # stubbing Aws::S3::Object
        remote_object = double(key: 'model.stl', size: 1, content_type: 'model/stl',
                               public_url: 'http://foo.com/model.stl', exists?: true)
        # rubocop:enable RSpec/VerifiedDoubles
        stub_direct_upload_bucket_object(remote_object)

        result = service.execute

        expect(result).to be_valid
        expect(result).not_to be_persisted
      end
    end
  end
end
