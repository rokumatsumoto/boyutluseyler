# == Schema Information
#
# Table name: blueprints
#
#  id           :bigint(8)        not null, primary key
#  url          :string           not null
#  url_path     :string           not null
#  size         :integer          not null
#  content_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  thumb_url    :string           default(""), not null
#  preview      :boolean          default(FALSE)
#

require 'spec_helper'

RSpec.describe Blueprint, type: :model do
  describe 'modules' do
    subject { described_class }

    it { is_expected.to include_module(ValidatableFile) }
  end

  describe 'constants' do
    subject { described_class }

    let(:preview_content_types) { %w[application/vnd.ms-pki.stl model/stl application/x-tgif] }
    let(:allowed_exts) { %w[stl obj zip] }
    let(:allowed_exts_regex) { /.[.](stl|obj|zip)\z/i }

    it { is_expected.to have_constant(:PREVIEW_CONTENT_TYPES, Array).with_value(preview_content_types) }
    it { is_expected.to have_constant(:ALLOWED_EXTS, Array).with_value(allowed_exts) }
    it { is_expected.to have_constant(:ALLOWED_EXTS_REGEX, Regexp).with_value(allowed_exts_regex) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:design_blueprint) }
  end

  describe 'validations' do
    describe 'url_path' do
      context 'when contains allowed file extensions' do
        it { is_expected.to allow_value('uploads/blueprint.stl').for(:url_path) }
        it { is_expected.to allow_value('uploads/blueprint.obj').for(:url_path) }
        it { is_expected.to allow_value('uploads/blueprint.zip').for(:url_path) }
        it { is_expected.to allow_value('uploads/blueprint.STL.STL').for(:url_path) }
      end

      context 'when contains not allowed file extensions' do
        it { is_expected.not_to allow_value('uploads/blueprint.ogex').for(:url_path) }
      end

      context 'when contains not allowed filename' do
        it { is_expected.not_to allow_value('uploads/blueprintstl').for(:url_path) }
        it { is_expected.not_to allow_value('.stl').for(:url_path) }
      end
    end
  end

  describe '#set_preview' do
    context 'when blueprint has no preview support' do
      let(:blueprint) { build_stubbed(:blueprint_no_preview, preview: nil) }

      it 'sets preview to false before validation' do
        blueprint.validate

        expect(blueprint.preview).to be false
      end
    end

    context 'when blueprint has preview support' do
      let(:blueprint) { build_stubbed(:blueprint, preview: nil) }

      it 'sets preview to true before validation' do
        blueprint.validate

        expect(blueprint.preview).to be true
      end
    end

    context 'when content type is not known' do
      let(:blueprint) { build_stubbed(:blueprint, content_type: nil, preview: nil) }

      before do
        allow(blueprint).to receive(:ensure_content_type_correct).and_return(nil)

        blueprint.validate
      end

      it 'sets preview to false' do
        expect(blueprint.preview).to be false
      end
    end
  end
end
