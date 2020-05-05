# frozen_string_literal: true

module Blueprints
  class BuildService < Blueprints::BaseService
    def execute
      validate!

      Blueprint.new.tap do |b|
        b.url = public_url
        b.url_path = blueprint.key
        b.size = blueprint.size
        b.content_type = blueprint.content_type
        b.thumb_url = ''
      end
    end

    private

    def raise_error(message)
      raise ValidationError, message
    end

    def validate!
      validate_object_existence!
    end

    def validate_object_existence!
      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Object.html#exists%3F-instance_method
      # TODO: add i18n, slack integration and "site administrator has been informed" message
      raise_error('File not found') unless blueprint.exists?
    end

    def blueprint
      @blueprint ||= bucket.object(params[:key])
    end

    def bucket
      DIRECT_UPLOAD_AWS_S3_BUCKET
    end

    # TODO: don't store bucket endpoint in DB or store but don't rely on that data
    # public_url (url column) should be used to quick access by administrators
    def public_url
      "#{Boyutluseyler.config[:direct_upload_endpoint]}/#{blueprint.key}"
    end
  end
end
