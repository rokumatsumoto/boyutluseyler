# frozen_string_literal: true

module Blueprints
  class BuildService < Blueprints::BaseService
    prepend ValidatesRemoteObject

    def execute
      validate!

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

    private

    def validate!
      # TODO: add i18n, slack integration and "site administrator has been informed" message
      raise ValidationError, 'File not found' unless remote_object_exists?
    end

    def bucket
      ObjectStorage::DirectUpload::Bucket
    end
  end
end
