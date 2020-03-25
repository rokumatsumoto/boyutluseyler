# == Schema Information
#
# Table name: designs
#
#  id                        :bigint(8)        not null, primary key
#  name                      :string(120)      not null
#  description               :text             not null
#  printing_settings         :text
#  model_file_format         :string
#  license_type              :string           not null
#  allow_comments            :boolean          default(TRUE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id                   :bigint(8)        not null
#  category_id               :bigint(8)        not null
#  slug                      :string
#  downloads_count           :integer          default(0), not null
#  hourly_downloads_count    :float            default(0.0), not null
#  popularity_score          :float            default(0.0), not null
#  home_popular_at           :datetime
#  likes_count               :integer          default(0), not null
#  hourly_downloads_count_at :datetime
#  cached_tag_names          :text
#

require 'spec_helper'

RSpec.describe Design, type: :model do
  describe 'modules' do
    subject { described_class }

    it { is_expected.to include_module(FriendlyId::History) }
    it { is_expected.to include_module(FriendlyId::Slugged) }
    it { is_expected.to include_module(Rolify::Resource) }
    it { is_expected.to include_module(Taggable) }
    it { is_expected.to include_module(Sortable) }

    context 'with FriendlyId config' do
      let(:friendly_id_config) { described_class.friendly_id_config }

      it 'uses a column named name to generate slug' do
        expect(friendly_id_config.base).to eq(:name)
      end
    end
  end

  describe 'constants' do
    subject { described_class }

    # rubocop:disable Metrics/LineLength
    it { is_expected.to have_constant(:HOURLY_DOWNLOAD_INTERVAL, ActiveSupport::Duration).with_value(1.hour) }
    it { is_expected.to have_constant(:POPULAR_INTERVAL, ActiveSupport::Duration).with_value(1.hour) }
    # rubocop:enable Metrics/LineLength
    it { is_expected.to have_constant(:MOST_DOWNLOADED_LIMIT, Integer).with_value(8) }
    it { is_expected.to have_constant(:POPULAR_LIMIT, Integer).with_value(12) }
    it { is_expected.to have_constant(:POPULARITY_EFFECT, Float).with_value(0.02) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:design_illustrations).order(position: :asc).inverse_of(:design) }
    it { is_expected.to have_many(:illustrations).through(:design_illustrations) }
    it { is_expected.to have_many(:design_blueprints).order(position: :asc).inverse_of(:design) }
    it { is_expected.to have_many(:blueprints).through(:design_blueprints) }
    it { is_expected.to have_one(:design_download).dependent(:destroy) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(120) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:license_type) }
    it { is_expected.to validate_presence_of(:design_illustrations) }
    it { is_expected.to validate_presence_of(:design_blueprints) }
  end
end
