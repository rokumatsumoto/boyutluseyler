# frozen_string_literal: true

class AvatarDirectUploadPolicy < BaseDirectUploadPolicy
  def key_prefix
    [
      'uploads',
      'user',
      'avatar-file',
      current_user_id
    ].join('/')
  end

  def content_length_range
    Range.new(1, 2_097_152)
  end

  def content_type_starts_with
    content_type_starts_with_image
  end
end
