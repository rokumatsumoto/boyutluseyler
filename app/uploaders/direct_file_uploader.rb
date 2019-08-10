# frozen_string_literal: true

class DirectFileUploader
  include ObjectStorage::Concern

  attr_reader :model, :provider_name, :uploader_context

  def initialize(model, provider_name, **uploader_context)
    @model = model
    @provider_name = provider_name
    @uploader_context = apply_context!(uploader_context)
  end

  def presigned_post
    direct_upload = ObjectStorage::DirectUpload.new(provider, @provider_name)
    direct_upload.presigned_post
  end

  def provider
    raise ArgumentError, 'missing uploader_context variables' unless @uploader_context

    case @provider_name
    when Providers::AWS.name.demodulize
      Providers::AWSDirectUpload.new(@model, object_key_prefix, object_content_length)
    end
  end

  def object_key_prefix
    case @model.name
    when Blueprint.name
      uploaders_key_prefix
    when Illustration.name
      uploaders_key_prefix
    end
  end

  def object_content_length
    case @model.name
    when Blueprint.name
      Blueprint.content_length_range
    when Illustration.name
      Illustration.content_length_range
    end
  end

  def uploaders_key_prefix
    [
      'uploaders',
      @current_user_id,
      "#{@model.name.downcase}-file",
      SecureRandom.uuid
    ].join('/')
  end

  private

  def apply_context!(uploader_context)
    @current_user_id = uploader_context.values_at(:current_user_id)

    !@current_user_id.nil?
  end
end
