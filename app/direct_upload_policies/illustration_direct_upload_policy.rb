# frozen_string_literal: true

class IllustrationDirectUploadPolicy < BaseDirectUploadPolicy
  def key_prefix
    key_prefix_for_design_file
  end

  delegate :content_length_range, to: :model

  def content_type_starts_with
    content_type_starts_with_image
  end

  private

  def model
    Illustration
  end
end
