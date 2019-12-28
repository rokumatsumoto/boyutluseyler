# frozen_string_literal: true

class BlueprintDirectUploadPolicy < BaseDirectUploadPolicy
  def key_prefix
    key_prefix_for_design_file
  end

  delegate :content_length_range, to: :model

  def content_type_starts_with
    # https://developer.mozilla.org/en-US/docs/Web/API/File/type
    # https://www.iana.org/assignments/media-types/media-types.xhtml#model
    # neither File API or AWS S3 could not detect model mime types
    ''
  end

  private

  def model
    Blueprint
  end
end
