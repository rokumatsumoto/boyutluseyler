# frozen_string_literal: true

class DirectUploadService
  attr_reader :model, :provider_name, :uploader_class, :uploader_context

  def initialize(model, provider_name, uploader_class = DirectFileUploader, **uploader_context)
    @model = model
    @provider_name = provider_name
    @uploader_class = uploader_class
    @uploader_context = uploader_context
  end

  def execute
    @uploader_class.new(@model, @provider_name, @uploader_context).presigned_post
  end
end
