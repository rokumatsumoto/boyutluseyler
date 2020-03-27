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
  specify do
    expect(described_class.new).to define_enum_for(:license_type)
      .with_values(
        license_none: 'license_none',
        cc_by: 'cc_by',
        cc_by_sa: 'cc_by_sa',
        cc_by_nd: 'cc_by_nd',
        cc_by_nc: 'cc_by_nc',
        cc_by_nc_sa: 'cc_by_nc_sa',
        cc_by_nc_nd: 'cc_by_nc_nd'
      )
      .backed_by_column_of_type(:string)
  end

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

    it { is_expected.to have_constant(:HOURLY_DOWNLOAD_INTERVAL, ActiveSupport::Duration).with_value(1.hour) }
    it { is_expected.to have_constant(:POPULAR_INTERVAL, ActiveSupport::Duration).with_value(1.hour) }

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

  describe '.home_popular' do
    let!(:popular2) { create(:design, popularity_score: 2) }
    let!(:popular1) { create(:design, popularity_score: 3) }
    let!(:popular3) { create(:design, popularity_score: 1) }

    it 'orders designs by the popularity score in descending order' do
      expect(described_class.home_popular).to eq([popular1, popular2, popular3])
    end

    it 'limits designs based on a POPULAR_LIMIT value' do
      stub_const("#{described_class}::POPULAR_LIMIT", 2)

      expect(described_class.home_popular.count).to eq(2)
    end
  end

  describe '#should_generate_new_friendly_id?' do
    subject(:design) { build_stubbed(:design, :with_slug) }

    context 'when name attribute is changed' do
      it 'generates matching slug' do
        design.name += ' updated'

        expect(design.should_generate_new_friendly_id?).to be true
      end
    end

    context 'when name attribute is not changed' do
      it 'does not generate matching slug' do
        expect(design.should_generate_new_friendly_id?).to be false
      end
    end

    context 'if record is new' do
      subject(:design) { build(:design) }

      it 'generates matching slug' do
        expect(design.should_generate_new_friendly_id?).to be true
      end
    end
  end
end
