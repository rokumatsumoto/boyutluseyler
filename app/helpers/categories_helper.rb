# frozen_string_literal: true

module CategoriesHelper
  def fetch_categories
    category_list = Rails.cache.fetch(category_list_cache_key) do
      Category.all.to_json
    end

    JSON.parse(category_list)
  end

  def fetch_random_categories(count = 4)
    fetch_categories.shuffle.sample(count)
  end

  def category_list_cache_key
    last_modified = Category.order(:updated_at).last

    return nil if last_modified.nil?

    last_modified_str = last_modified.updated_at.utc.to_s(:number)

    "all_categories/#{last_modified_str}"
  end
end
