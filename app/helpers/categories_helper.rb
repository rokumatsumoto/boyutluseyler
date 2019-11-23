# frozen_string_literal: true

module CategoriesHelper
  def fetch_categories
    categories = Rails.cache.fetch(category_list_cache_key) { Category.all.to_json }

    JSON.load(categories)
  end

  def fetch_random_categories(count = 4)
    fetch_categories.shuffle.sample(count)
  end

  def category_list_cache_key
    last_modified = Category.order(:updated_at).last

    last_modified_str = last_modified.updated_at.utc.to_s(:number)

    "all_categories/#{last_modified_str}"
  end
end
