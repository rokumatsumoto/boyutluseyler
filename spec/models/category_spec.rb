# == Schema Information
#
# Table name: categories
#
#  id          :bigint(8)        not null, primary key
#  name        :string(50)       not null
#  description :text
#  list_order  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

require 'spec_helper'

RSpec.describe Category, type: :model do
  describe 'modules' do
    subject { described_class }

    it { is_expected.to include_module(FriendlyId::History) }
    it { is_expected.to include_module(FriendlyId::Slugged) }

    context 'for FriendlyId config' do
      let(:friendly_id_config) { described_class.friendly_id_config }

      it 'uses a column named name to generate slug' do
        expect(friendly_id_config.base).to eq(:name)
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:designs) }
  end

  describe 'invalidating all categories cache' do
    let(:category) { create(:category) }

    it 'calls invalidate_all_categories_cache when a category destroyed' do
      allow(category).to receive(:invalidate_all_categories_cache)

      category.destroy!

      expect(category).to have_received(:invalidate_all_categories_cache)
    end
  end

  describe '.order_by_list_order' do
    let!(:category2) { create(:category, list_order: 2) }
    let!(:category1) { create(:category, list_order: 1) }
    let!(:category3) { create(:category) }

    it 'orders categories by the list order in ascending order' do
      expect(described_class.order_by_list_order).to eq([category1, category2, category3])
    end
  end

  describe '.order_by_updated_at' do
    let!(:category2) { create(:category, updated_at: 3.months.ago) }
    let!(:category1) { create(:category, updated_at: 6.months.ago) }
    let!(:category3) { create(:category) }

    it 'orders categories by updated date in ascending order' do
      expect(described_class.order_by_updated_at).to eq([category1, category2, category3])
    end
  end

  describe '.last_modified' do
    let(:category2) { build_stubbed(:category, updated_at: 3.months.ago) }
    let(:category1) { build_stubbed(:category, updated_at: 6.months.ago) }

    it 'returns the last updated category' do
      allow(described_class).to receive(:order_by_updated_at).and_return([category1, category2])

      expect(described_class.last_modified).to eq(category2)
    end
  end

  describe '#invalidate_all_categories_cache' do
    context 'with a non-existing cache key' do
      it 'returns nil' do
        allow(described_class).to receive(:category_list_cache_key).and_return(nil)

        expect(described_class.new.invalidate_all_categories_cache).to be_nil
      end
    end

    context 'with an existing cache key' do
      it 'invalidates cache for all categories' do
        cache_mock = spy

        allow(described_class).to receive(:category_list_cache_key).and_return('all_categories')
        allow(Rails).to receive(:cache).and_return(cache_mock)

        described_class.new.invalidate_all_categories_cache

        expect(cache_mock).to have_received(:delete).with('all_categories')
      end
    end
  end

  describe '.cached_categories' do
    before do
      allow(described_class).to receive(:category_list_cache_key).and_return(nil)
    end

    it 'returns categories sorted by list order ascending' do
      allow(described_class).to receive(:order_by_list_order)

      described_class.cached_categories

      expect(described_class).to have_received(:order_by_list_order)
    end

    context 'for caching' do
      let(:category_list) do
        build_stubbed(:category)
        build_stubbed(:category)
      end

      it 'stores category list in JSON format and parse when it needs' do
        allow(described_class).to receive(:order_by_list_order).and_return(category_list)
        cached_data = category_list.to_json

        expect(described_class.cached_categories).to eq(JSON.parse(cached_data))
      end
    end
  end

  describe '.category_list_cache_key' do
    context 'when there is no category' do
      it 'returns nil' do
        allow(described_class).to receive(:last_modified).and_return(nil)

        expect(described_class.category_list_cache_key).to be_nil
      end
    end

    context 'when there is a category' do
      let(:last_modified) { instance_double(described_class, updated_at: Time.current) }

      it 'returns a cache key using the last modified category\'s date and time' do
        allow(described_class).to receive(:last_modified).and_return(last_modified)

        last_modified_str = last_modified.updated_at.utc.to_s(:number)

        expect(described_class.category_list_cache_key).to eq("all_categories/#{last_modified_str}")
      end
    end
  end

  it_behaves_like 'generates new friendly_id when attribute changed on model', :category, :name
end
