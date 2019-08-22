# frozen_string_literal: true

module ObjectStorage
  class DirectUpload
    include Boyutluseyler::Utils::StrongMemoize
    EXPIRE_OFFSET = 15.minutes

    RemoteStoreError = Class.new(StandardError)

    attr_reader :model

    def initialize(model)
      @model = model
    end

    def presigned_post(obj_key_prefix, obj_content_length)
      bucket.presigned_post(presigned_post_options(obj_key_prefix, obj_content_length))
    end

    private

    def bucket
      DIRECT_UPLOAD_AWS_S3_BUCKET
    end

    def presigned_post_options(obj_key_prefix, obj_content_length)
      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Bucket.html#presigned_post-instance_method
      {
        key: generate_key(obj_key_prefix),
        key_starts_with: key_starts_with(obj_key_prefix),
        content_type_starts_with: content_type_starts_with,
        success_action_status: Boyutluseyler.config[:direct_upload_success_action_status],
        acl: Boyutluseyler.config[:direct_upload_acl],
        signature_expiration: expire_at,
        cache_control: Boyutluseyler.config[:direct_upload_cache_control],
        content_length_range: obj_content_length
      }
    end

    def generate_key(obj_key_prefix)
      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/PresignedPost.html#key-instance_method
      key_starts_with(obj_key_prefix) + '/${filename}'
    end

    def key_starts_with(obj_key_prefix)
      strong_memoize(:key_starts_with) { obj_key_prefix }
    end

    def content_type_starts_with
      case model.name
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
end
