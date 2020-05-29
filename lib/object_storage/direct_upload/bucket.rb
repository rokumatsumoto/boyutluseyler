# frozen_string_literal: true

# Wrapper class for AWS::S3::Bucket

require_relative 'presigned_post'

module ObjectStorage
  module DirectUpload
    class Bucket
      def initialize(bucket: DIRECT_UPLOAD_BUCKET)
        @bucket = bucket
      end

      delegate :object, to: :bucket

      def presigned_post(policy)
        PresignedPost.new(bucket, policy).create
      end
    end
  end
end
