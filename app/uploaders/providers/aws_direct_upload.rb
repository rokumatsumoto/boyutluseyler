# rubocop:disable Naming/FileName
# frozen_string_literal: true

module Providers
  class AWSDirectUpload < AWS
    EXPIRE_OFFSET = 15.minutes

    attr_reader :model, :object_key_prefix, :object_content_length

    def initialize(model, object_key_prefix, object_content_length)
      @model = model
      @object_key_prefix = object_key_prefix
      @object_content_length = object_content_length
    end

    def bucket
      DIRECT_UPLOAD_AWS_S3_BUCKET
    end

    def presigned_post_options
      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Bucket.html#presigned_post-instance_method
      {
        key: generate_key,
        key_starts_with: key_starts_with,
        content_type_starts_with: content_type_starts_with,
        success_action_status: Boyutluseyler.config[:direct_upload_success_action_status],
        acl: Boyutluseyler.config[:direct_upload_acl],
        signature_expiration: expire_at,
        cache_control: Boyutluseyler.config[:direct_upload_cache_control],
        content_length_range: @object_content_length
      }
    end

    def generate_key
      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/PresignedPost.html#key-instance_method
      key_starts_with + '/${filename}'
    end

    def key_starts_with
      strong_memoize(:key_starts_with) { @object_key_prefix }
    end

    def content_type_starts_with
      case @model.name
      when Blueprint.name
        # https://developer.mozilla.org/en-US/docs/Web/API/File/type
        # https://www.iana.org/assignments/media-types/media-types.xhtml#model
        # neither File API or AWS S3 could not detect model mime types
        ''
      when Illustration.name
        'image/'
      end
    end

    def expire_at
      Time.now.utc + EXPIRE_OFFSET
    end
  end
  # rubocop:enable Naming/FileName
end
