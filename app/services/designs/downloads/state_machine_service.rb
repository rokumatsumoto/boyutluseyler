# frozen_string_literal: true

module Designs
  module Downloads
    class StateMachineService < Designs::BaseService
      def execute
        return presigned_url if ready?

        return '' if requested?

        AvailableDownloadBroadcastWorker.perform_async(design.id)

        ''
      end

      private

      def ready?
        design_download.ready?
      end

      def requested?
        design_download.requested?
      end

      def presigned_url
        PresignedUrlService.new(nil, key: design_download.url).execute
      end

      def design_download
        @design_download ||= DesignDownload.find_by(design_id: design.id)
      end
    end
  end
end
