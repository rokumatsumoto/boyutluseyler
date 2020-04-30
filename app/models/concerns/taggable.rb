# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  included do
    Gutentag::ActiveRecord.call self
  end

  # Return the tag names separated by commas and spaces
  def tags_as_string
    tag_names.join(', ')
  end

  # Split up the provided value by commas and spaces
  def tags_as_string=(string)
    self.tag_names = string.split(/,\s*/).map(&:strip)

    self.cached_tag_names = tags_as_string
  end

  def cached_tag_name_list
    return [] if cached_tag_names.blank?

    cached_tag_names.split(/,\s*/)
  end
end
