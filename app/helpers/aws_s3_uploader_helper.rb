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
      content_length_range: 104_857_600 # TODO: constants
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

  def validate_content_type(type, object_file_name, object_content_type)
    @content_type = object_content_type

    invalid = (@content_type.nil? || @content_type == '') ||
              allowed_content_types(type).none?(@content_type)

    content_type_by_filename(object_file_name) if invalid
  end

  def validate_content_type_by_object(type, object, new_options = {})
    @content_type = object.content_type

    invalid = (@content_type.nil? || @content_type == '') ||
              allowed_content_types(type).none?(@content_type)

    update_content_type(object, new_options) if invalid
  end

  def update_content_type(object, new_options)
    options = {
      acl: object_acl,
      metadata_directive: 'REPLACE',
      content_type: content_type_by_filename(object.key)
    }
    options.merge!(new_options)

    copy_object(object, options)
  end

  def copy_object(object, new_options)
    # Build a new options object
    options = {}

    # Merge in the object's existing properties
    existing_options = object.data.to_h.slice(:metadata, :expires, :cache_control)
    options.merge!(existing_options)

    # Add our new updates
    options.merge!(new_options)

    begin
      object.copy_to({ bucket: S3_BUCKET.name, key: object.key }, options)
    rescue StandardError => e
      puts "Exception Raised: #{e}"
    end
  end

  def content_type_by_filename(filename)
    filename = MiniMime.lookup_by_filename(filename)
    @content_type = filename.content_type unless filename.nil?
  end

  private

  def object_acl
    Rails.application.credentials.aws_s3[:acl]
  end
end
