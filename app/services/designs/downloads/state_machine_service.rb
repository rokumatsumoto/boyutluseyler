# frozen_string_literal: true

module Designs
  module Downloads
    class StateMachineService < Designs::BaseService
      def execute
        return presigned_url if ready?

        return '' if requested?

        # test AvailableDownloadBroadcast.new(design.id).perform
        AvailableDownloadBroadcastWorker.perform_async(design.id)
        ''
      end

      def ready?
        step == 'ready'
      end

      def requested?
        step == 'requested'
      end

      def presigned_url
        PresignedUrlService.new(nil, key: design_download.url).execute
      end

      def step
        return design_download.step if design_download

        nil
      end

      def design_download
        @design_download ||= DesignDownload.find_by(design_id: design.id)
      end
    end
  end
end
