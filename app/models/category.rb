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

  scope :order_by_list_order, -> { order(:list_order) }
  scope :order_by_updated_at, -> { order(:updated_at) }
  scope :last_modified, -> { order_by_updated_at.last }

  def invalidate_all_categories_cache
    return if self.class.category_list_cache_key.nil?

    Rails.cache.delete(self.class.category_list_cache_key)
  end

  class << self
    def cached_categories
      category_list = Rails.cache.fetch(category_list_cache_key) do
        order_by_list_order.to_json
      end

      JSON.parse(category_list)
    end

    def category_list_cache_key
      return nil if last_modified.blank?

      last_modified_str = last_modified.updated_at.utc.to_s(:number)

      "all_categories/#{last_modified_str}"
    end
  end

  private

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
