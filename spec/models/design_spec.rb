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

  describe '#preview_blueprints' do
    context 'with blueprints that support preview' do
      subject(:blueprints) { design.preview_blueprints }

      let(:design) { create(:design, blueprint_preview: true) }

      it 'returns blueprints' do
        expect(blueprints.exists?).to be true
      end

      it 'returns proper attributes for preview' do
        expect(blueprints.take.attributes.keys).to match_array(%w[id url thumb_url])
      end
    end

    context 'with blueprints that do not support preview' do
      let(:design) { create(:design, blueprint_preview: false) }

      it 'does not return blueprints' do
        expect(design.preview_blueprints.empty?).to be true
      end
    end
  end

  describe '#preview_illustrations' do
    subject(:illustrations) { design.preview_illustrations }

    let(:design) { create(:design) }

    it 'returns illustrations' do
      expect(illustrations.exists?).to be true
    end

    it 'returns proper attributes for preview' do
      expect(illustrations.take.attributes.keys).to match_array(%w[id thumb_url url])
    end
  end

  describe '#cached_category_name' do
    it 'returns the category name of design' do
      design = build_stubbed(:design)
      category = instance_double(Category, name: 'name')

      allow(design).to receive(:category).and_return(category)

      expect(design.cached_category_name).to eq(category.name)
    end
  end

  describe '#cached_user' do
    it 'returns the profile info of design creator' do
      design = build_stubbed(:design)
      user = instance_double(User, username: 'username', avatar_url: 'avatar_url')

      allow(design).to receive(:user).and_return(user)

      attributes = design.cached_user.instance_variable_get('@table').keys
      expect(attributes).to match_array(%i[username avatar_url])
      expect(design.cached_user.username).to eq(user.username)
    end
  end

  describe '.most_downloaded_with_illustration' do
    it 'returns most downloaded designs with the first illustration' do
      allow(described_class).to receive(:most_downloaded).and_call_original
      allow(described_class).to receive(:with_illustration).and_call_original

      described_class.most_downloaded_with_illustration

      expect(described_class).to have_received(:most_downloaded)
      expect(described_class).to have_received(:with_illustration)
    end
  end

  describe '.most_popular_with_illustration' do
    it 'returns most popular designs with the first illustration' do
      allow(described_class).to receive(:most_popular).and_call_original
      allow(described_class).to receive(:with_illustration).and_call_original

      described_class.most_popular_with_illustration

      expect(described_class).to have_received(:most_popular)
      expect(described_class).to have_received(:with_illustration)
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '.sort_by_attribute' do
    context 'when order by downloads_count' do
      let!(:design2) { create(:design, downloads_count: 1) }
      let!(:design1) { create(:design, downloads_count: 2) }
      let!(:design3) { create(:design) }

      context 'with descending' do
        it 'sorts by downloads count descending' do
          designs = described_class.sort_by_attribute('downloads_count_desc')

          expect(designs).to eq([design1, design2, design3])
        end
      end

      context 'with ascending' do
        it 'sorts by downloads count ascending' do
          designs = described_class.sort_by_attribute('downloads_count_asc')

          expect(designs).to eq([design3, design2, design1])
        end
      end
    end

    context 'when order by likes_count' do
      let!(:design2) { create(:design, likes_count: 1) }
      let!(:design1) { create(:design, likes_count: 2) }
      let!(:design3) { create(:design) }

      context 'with descending' do
        it 'sorts by likes count descending' do
          designs = described_class.sort_by_attribute('likes_count_desc')

          expect(designs).to eq([design1, design2, design3])
        end
      end

      context 'with ascending' do
        it 'sorts by likes count ascending' do
          designs = described_class.sort_by_attribute('likes_count_asc')

          expect(designs).to eq([design3, design2, design1])
        end
      end
    end

    context 'when order by home_popular_at' do
      let!(:design2) { create(:design, home_popular_at: 5.days.ago) }
      let!(:design1) { create(:design, home_popular_at: 1.day.ago) }
      let!(:design3) { create(:design, home_popular_at: 7.days.ago) }

      context 'with descending' do
        it 'sorts designs according to descending popularity' do
          designs = described_class.sort_by_attribute('home_popular_at_desc')

          expect(designs).to eq([design1, design2, design3])
        end
      end

      context 'with ascending' do
        it 'sorts designs according to ascending popularity' do
          designs = described_class.sort_by_attribute('home_popular_at_asc')

          expect(designs).to eq([design3, design2, design1])
        end
      end
    end

    context 'when order by descending created date' do
      let!(:design2) { create(:design, created_at: 5.days.ago) }
      let!(:design1) { create(:design, created_at: 1.day.ago) }
      let!(:design3) { create(:design, created_at: 7.days.ago) }

      it 'sorts by descending created date using default simple sorts' do
        designs = described_class.sort_by_attribute('created_desc')

        expect(designs).to eq([design1, design2, design3])
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe '.most_downloaded' do
    before do
      stub_const("#{described_class}::HOURLY_DOWNLOAD_INTERVAL", 1.hour)
    end

    context 'when there are designs that have never been downloaded' do
      let!(:design) { create(:design, :not_downloaded) }

      it 'does not return these ones' do
        expect(described_class.most_downloaded).not_to include(design)
      end
    end

    context 'for hourly download calculation' do
      let!(:design1) { create(:design, :downloaded, created_at: 30.minutes.ago) }
      let!(:design2) { create(:design, :downloaded, created_at: 2.hours.ago) }
      let!(:design3) { create(:design, :downloaded) }

      it 'does not return designs not eligible for hourly download calculation' do
        expect(described_class.most_downloaded).not_to include(design1, design3)
      end

      it 'returns designs eligible for hourly download calculation' do
        expect(described_class.most_downloaded).to eq([design2])
      end
    end

    context 'when designs have different hourly download count' do
      let!(:design2) { create(:design, :normal_download_per_hour) }
      let!(:design1) { create(:design, :high_download_per_hour) }
      let!(:design3) { create(:design, :low_download_per_hour) }

      it 'orders designs by hourly download count in descending order' do
        expect(described_class.most_downloaded).to eq([design1, design2, design3])
      end

      it 'limits designs based on a MOST_DOWNLOADED_LIMIT value' do
        stub_const("#{described_class}::MOST_DOWNLOADED_LIMIT", 2)

        expect(described_class.most_downloaded.count).to eq(2)
      end
    end

    context 'when multiple designs have the same hourly download count' do
      let!(:design2) { create(:design, :normal_download_per_hour, created_at: 6.months.ago) }
      let!(:design1) { create(:design, :normal_download_per_hour, created_at: 2.months.ago) }

      it 'orders designs by descending created date' do
        expect(described_class.most_downloaded).to eq([design1, design2])
      end
    end
  end

  describe '.most_popular' do
    let!(:design2) { create(:design, popularity_score: 1) }
    let!(:design1) { create(:design, popularity_score: 2) }
    let!(:design3) { create(:design) }

    it 'orders designs by the popularity score in descending order' do
      expect(described_class.most_popular).to eq([design1, design2, design3])
    end

    it 'limits designs based on a POPULAR_LIMIT value' do
      stub_const("#{described_class}::POPULAR_LIMIT", 2)

      expect(described_class.most_popular.count).to eq(2)
    end
  end

  describe '.popular' do
    let!(:design1) { create(:design, :unpopular) }
    let!(:design2) { create(:design, :popular) }

    context 'when there are popular designs' do
      it 'returns these ones' do
        expect(described_class.popular).to eq([design2])
      end
    end

    context 'when there are unpopular designs' do
      it 'does not return these ones' do
        expect(described_class.popular).not_to include(design1)
      end
    end
  end

  describe '.with_illustration' do
    let!(:design) { create(:design) }

    context 'with first illustration' do
      it 'returns the first illustration of design' do
        result = described_class.with_illustration.select('illustrations.id as illustration_id')
        # TODO: get rid of select if you can

        expect(result.first.illustration_id).to eq(design.illustrations.first.id)
      end

      it 'does not return noninitial illustration of design' do
        expect(described_class.with_illustration.count(:all)).to eq(1)
      end
    end

    it 'returns proper attributes' do
      keys = described_class.with_illustration.take.attributes.keys

      expect(keys).to match_array(%w[id name slug medium_url category_slug tag_names])
    end
  end

  describe '.cached_most_downloaded' do
    it 'calculates most downloaded designs and returns them' do
      hourly_downloads_count_service = instance_spy(Designs::Downloads::HourlyDownloadsCountService)
      allow(described_class).to receive(:hourly_downloads_count_service)
        .and_return(hourly_downloads_count_service)
      allow(described_class).to receive(:most_downloaded_with_illustration)

      described_class.cached_most_downloaded

      expect(hourly_downloads_count_service).to have_received(:execute)
      expect(described_class).to have_received(:most_downloaded_with_illustration)
    end

    context 'for caching' do
      let(:design_list) do
        build_stubbed(:design)
        build_stubbed(:design)
      end

      it 'stores most downloaded design list in JSON format and parse when it needs' do
        allow(described_class).to receive(:most_downloaded_with_illustration).and_return(design_list)
        cached_data = design_list.to_json(except: :tag_names)

        expect(described_class.cached_most_downloaded).to eq(JSON.parse(cached_data))
      end
    end
  end

  describe '.cached_popular_designs' do
    it 'finds the most popular designs for the homepage' do
      become_popular_service = instance_spy(Designs::BecomePopularService)
      allow(described_class).to receive(:become_popular_service).and_return(become_popular_service)
      allow(described_class).to receive(:most_popular_with_illustration)

      described_class.cached_popular_designs

      expect(become_popular_service).to have_received(:execute)
      expect(described_class).to have_received(:most_popular_with_illustration)
    end

    context 'for caching' do
      let(:design_list) do
        build_stubbed(:design)
        build_stubbed(:design)
      end

      it 'stores most popular design list in JSON format and parse when it needs' do
        allow(described_class).to receive(:most_popular_with_illustration).and_return(design_list)
        cached_data = design_list.to_json(except: :tag_names)

        expect(described_class.cached_popular_designs).to eq(JSON.parse(cached_data))
      end
    end
  end

  describe '.invalidate_most_downloaded_cache' do
    it 'invalidates cache for most downloaded design list' do
      cache_mock = spy

      allow(Rails).to receive(:cache).and_return(cache_mock)

      described_class.invalidate_most_downloaded_cache

      expect(cache_mock).to have_received(:delete).with('most_downloaded')
    end
  end

  describe '.invalidate_popular_designs_cache' do
    it 'invalidates cache for most popular design list' do
      cache_mock = spy

      allow(Rails).to receive(:cache).and_return(cache_mock)

      described_class.invalidate_popular_designs_cache

      expect(cache_mock).to have_received(:delete).with('popular_designs')
    end
  end

  describe '#should_generate_new_friendly_id?' do
    subject(:design) { build_stubbed(:design, :with_slug) }

    context 'when name attribute is changed' do
      it 'generates matching slug' do
        design.name += ' updated'

        expect(design.send(:should_generate_new_friendly_id?)).to be true
      end
    end

    context 'when name attribute is not changed' do
      it 'does not generate matching slug' do
        expect(design.send(:should_generate_new_friendly_id?)).to be false
      end
    end

    context 'if record is new' do
      subject(:design) { build(:design) }

      it 'generates matching slug' do
        expect(design.send(:should_generate_new_friendly_id?)).to be true
      end
    end
  end
end
