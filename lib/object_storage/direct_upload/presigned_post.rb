# frozen_string_literal: true

# Wrapper class for Aws::S3::PresignedPost

module ObjectStorage
  module DirectUpload
    class PresignedPost
      EXPIRE_OFFSET = 15.minutes

      attr_reader :bucket, :policy

      def initialize(bucket, policy)
        @bucket = bucket
        @policy = policy
      end

      def create
        bucket.presigned_post(presigned_post_options)
      end

      private

      def presigned_post_options
        # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Bucket.html#presigned_post-instance_method
        # TODO: consider moving Boyutluseyler.config policies into related policy class
        {
          key: generate_key(policy.key_prefix),
          key_starts_with: key_starts_with(policy.key_prefix),
          content_type_starts_with: policy.content_type_starts_with,
          success_action_status: Boyutluseyler.config[:direct_upload_success_action_status],
          acl: Boyutluseyler.config[:direct_upload_acl],
          signature_expiration: expire_at,
          cache_control: Boyutluseyler.config[:direct_upload_cache_control],
          content_length_range: policy.content_length_range
        }
      end

      def generate_key(key_prefix)
        # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/PresignedPost.html#key-instance_method
        key_starts_with(key_prefix) + '/${filename}'
      end

      def key_starts_with(key_prefix)
        @key_starts_with ||= key_prefix
      end

      def expire_at
        Time.current.utc + EXPIRE_OFFSET
      end
    end
  end
end
