# frozen_string_literal: true

module Files
  module DirectUpload
    class CreatePresignedPostService
      attr_reader :policy

      def initialize(policy, **direct_upload_context)
        @policy = policy.new(direct_upload_context)
      end

      def execute
        direct_upload.presigned_post
      end

      private

      def direct_upload
        ObjectStorage::DirectUpload.new(policy)
      end
    end
  end
end
