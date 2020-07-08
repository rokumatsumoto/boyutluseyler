# frozen_string_literal: true

class BaseDirectUploadPolicy
  protected

  attr_reader :current_user_id

  def initialize(**direct_upload_context)
    @current_user_id = direct_upload_context[:current_user_id]
  end

  def key_prefix
    nil
  end

  def key_prefix_for_design_file
    [
      'uploads',
      'design',
      "#{model.name.downcase}-file",
      current_user_id,
      SecureRandom.uuid
    ].join('/')
  end

  def content_length_range
    nil
  end

  def content_type_starts_with
    nil
  end

  def content_type_starts_with_image
    'image/'
  end

  def model
    nil
  end
end
