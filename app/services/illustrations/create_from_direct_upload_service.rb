# frozen_string_literal: true

module Illustrations
  class CreateFromDirectUploadService < Illustrations::BaseService
    include ValidatesRemoteObject

    def initialize(bucket, user = nil, params = {})
      @bucket = bucket
      @current_user = user
      @key = params.delete(:key)
    end

    def execute
      find_remote_object!

      illustration = build_illustration

      if illustration.save
        success(illustration: illustration)
      else
        error(illustration_save_error(illustration), :unprocessable_entity)
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

    def build_illustration
      Illustration.new.tap do |i|
        # TODO: don't store bucket endpoint in DB or store but don't rely on that data.
        # the object may have been moved to a different bucket or
        # bucket endpoint may have been changed
        # public_url (url) should be used for quick access by administrators
        i.url = remote_object.public_url
        i.url_path = remote_object.key
        i.size = remote_object.size
        i.content_type = remote_object.content_type
        i.large_url = public_url_for_size(:large)
        i.medium_url = public_url_for_size(:medium)
        i.thumb_url = public_url_for_size(:thumb)
      end
    end

    def public_url_for_size(size)
      Boyutluseyler::PathHelper.append_suffix_before_extension(processed_public_url, "_#{size}")
    end

    def processed_public_url
      "#{Boyutluseyler.config[:processed_endpoint]}/#{remote_object.key}"
    end

    def illustration_save_error(illustration)
      illustration.errors.full_messages.join(', ')
    end
  end
end
