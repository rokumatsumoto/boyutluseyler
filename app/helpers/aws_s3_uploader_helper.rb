# frozen_string_literal: true

module AWSS3UploaderHelper
  # TODO: MOVE ALL
  def render_presigned_post(type)
    presigned_url = S3_BUCKET.presigned_post(
      key: generate_key(type),
      key_starts_with: key_starts_with(type),
      content_type_starts_with: content_type_starts_with(type),
      success_action_status: Rails.application.credentials.aws_s3[:success_action_status],
      acl: object_acl,
      signature_expiration: (Time.now.utc + 15.minutes), # TODO: constants
      cache_control: 'public, max-age=315576000', # TODO: constants
      content_length_range: 1..104_857_600 # TODO: constants
    )

    render json: presigned_url.fields, status: :ok
  end

  def generate_key_starts_with(type)
    [
      'uploaders',
      current_user.id,
      "#{type}-file",
      SecureRandom.uuid
    ].join('/')
  end

  def key_starts_with(type = nil)
    @key_starts_with ||= generate_key_starts_with(type)
  end

  def generate_key_path(type)
    key_starts_with(type) + '/${filename}'
  end

  def generate_key(type)
    case type
    when :illustration
      generate_key_path(type)
    when :blueprint
      generate_key_path(type)
    end
  end

  def content_type_starts_with(type)
    case type
    when :illustration
      'image/'
    when :blueprint
      ''
    end
  end

  def allowed_content_types(type)
    case type
    when :illustration
      %w[image/png image/gif image/jpeg]
    when :blueprint
      %w[application/vnd.ms-pki.stl
         model/stl
         image/x-3ds
         application/x-tgif
         application/zip]
    end
  end

  def validate_content_type(type, obj_file_name, obj_content_type)
    invalid = obj_content_type.blank? || allowed_content_types(type).none?(obj_content_type)

    return content_type_by_filename(obj_file_name) if invalid

    obj_content_type
  end

  def content_type_by_filename(filename)
    mime_info = MiniMime.lookup_by_filename(filename)

    return mime_info.content_type unless mime_info.nil?

    ''
  end

  private

  def object_acl
    Rails.application.credentials.aws_s3[:acl]
  end
end
