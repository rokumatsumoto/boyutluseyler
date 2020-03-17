# frozen_string_literal: true

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

class Category < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: %i[slugged history]

  has_many :designs

  after_destroy :invalidate_all_categories_cache # TODO: delegate to service

  def should_generate_new_friendly_id?
    name_changed?
  end

  def invalidate_all_categories_cache
    unless self.class.category_list_cache_key.nil?
      Rails.cache.delete(self.class.category_list_cache_key)
    end
  end

  # Class methods
  #
  class << self
    def cached_categories
      category_list = Rails.cache.fetch(category_list_cache_key) do
        order(:list_order).to_json
      end

      JSON.parse(category_list)
    end

    def category_list_cache_key
      last_modified = order(:updated_at).last

      return nil if last_modified.nil?

      last_modified_str = last_modified.updated_at.utc.to_s(:number)

      "all_categories/#{last_modified_str}"
    end
  end
end
