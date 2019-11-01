# frozen_string_literal: true

module Designs
  module Downloads
    class PresignedUrlService < ::BaseService
      def execute
        signer = Aws::S3::Presigner.new(client: client)

        signer.presigned_url(
          :get_object,
          bucket: bucket_name,
          key: params[:key],
          expires_in: expires_in
        )
      end

      private

      def client
        DIRECT_UPLOAD_AWS_S3_CLIENT
      end

      def bucket_name
        Boyutluseyler.config[:direct_upload_bucket_name]
      end

      def expires_in
        Boyutluseyler.config[:presigned_url_expires_in]
      end
    end
  end
end
