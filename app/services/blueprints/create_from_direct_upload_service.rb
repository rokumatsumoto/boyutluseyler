# frozen_string_literal: true

module Blueprints
  class CreateFromDirectUploadService < Blueprints::BaseService
    include ValidatesRemoteObject

    def initialize(bucket, user = nil, params = {})
      @bucket = bucket
      @current_user = user
      @key = params.delete(:key)
    end

    def execute
      find_remote_object!

      blueprint = build_blueprint

      if blueprint.save
        success(blueprint: blueprint)
      else
        error(blueprint_save_error(blueprint), :unprocessable_entity)
      end
    rescue ValidationError => e
      error(e.message, :not_found)
    end

    private

    attr_reader :bucket, :key

    def find_remote_object!
      # TODO: add i18n, slack integration and "site administrator has been informed" message
      raise ValidationError, 'File not found' unless remote_object_exists?
    end

    def build_blueprint
      Blueprint.new.tap do |b|
        # TODO: don't store bucket endpoint in DB or store but don't rely on that data.
        # the object may have been moved to a different bucket or
        # bucket endpoint may have been changed
        # public_url (url) should be used for quick access by administrators
        b.url = remote_object.public_url
        b.url_path = remote_object.key
        b.size = remote_object.size
        b.content_type = remote_object.content_type
        b.thumb_url = ''
      end
    end

    def blueprint_save_error(blueprint)
      blueprint.errors.full_messages.join(', ')
    end
  end
end
