# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  included do
    Gutentag::ActiveRecord.call self
  end

  # Return the tag names separated by a comma and space
  def tags_as_string
    tag_names.join(', ')
  end

  # Split up the provided value by commas and (optional) spaces.
  def tags_as_string=(string)
    self.tag_names = string.split(/,\s*/)
    self.cached_tag_names = string
  end

  def cached_tag_name_list
    cached_tag_names.split(/,\s*/)
  end
end
