# frozen_string_literal: true

module Files
  module DirectUpload
    class CreatePresignedPostService
      attr_reader :policy

      def initialize(policy, **direct_upload_context)
        @policy = policy.new(direct_upload_context)
      end

      def execute
        direct_upload_bucket.presigned_post(policy)
      end

      private

      def direct_upload_bucket
        ObjectStorage::DirectUpload::Bucket.new
      end
    end
  end
end
