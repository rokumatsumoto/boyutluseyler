# == Schema Information
#
# Table name: illustrations
#
#  id           :bigint(8)        not null, primary key
#  url          :string           not null
#  url_path     :string           not null
#  size         :integer          not null
#  content_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  large_url    :string           default(""), not null
#  medium_url   :string           default(""), not null
#  thumb_url    :string           default(""), not null
#

require 'spec_helper'

RSpec.describe Illustration, type: :model do
  describe 'modules' do
    subject { described_class }

    it { is_expected.to include_module(ValidatableFile) }
  end

  describe 'constants' do
    subject { described_class }


    let(:allowed_content_types) { %w[image/png image/gif image/jpeg] }
    let(:allowed_exts) { %w[png jpg jpeg gif] }
    let(:allowed_exts_regex) { /.[.](png|jpg|jpeg|gif)\z/i }

    it { is_expected.to have_constant(:ALLOWED_CONTENT_TYPES, Array).with_value(allowed_content_types) }
    it { is_expected.to have_constant(:ALLOWED_EXTS, Array).with_value(allowed_exts) }
    it { is_expected.to have_constant(:ALLOWED_EXTS_REGEX, Regexp).with_value(allowed_exts_regex) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:design_illustration) }
  end

  describe 'validations' do
    describe 'url_path' do
      context 'when contains allowed file extensions' do
        it { is_expected.to allow_value('uploads/illustration.png').for(:url_path) }
        it { is_expected.to allow_value('uploads/illustration.jpg').for(:url_path) }
        it { is_expected.to allow_value('uploads/illustration.jpeg').for(:url_path) }
        it { is_expected.to allow_value('uploads/illustration.gif').for(:url_path) }
        it { is_expected.to allow_value('uploads/illustration.JPG.JPG').for(:url_path) }
      end

      context 'when contains not allowed file extensions' do
        it { is_expected.not_to allow_value('uploads/illustration.tiff').for(:url_path) }
      end

      context 'when contains not allowed filename' do
        it { is_expected.not_to allow_value('uploads/illustrationjpg').for(:url_path) }
        it { is_expected.not_to allow_value('.jpg').for(:url_path) }
      end
    end
  end
end
