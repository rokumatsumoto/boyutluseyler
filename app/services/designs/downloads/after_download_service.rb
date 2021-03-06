# frozen_string_literal: true

module Designs
  module Downloads
    class AfterDownloadService
      attr_reader :current_user, :controller, :params
      attr_accessor :design

      def initialize(design, user = nil, params = {})
        @design = design
        @current_user = user
        @controller = params.delete(:controller)
        @params = params.dup
      end

      def execute
        controller.ensure_new_visit_created_before_ahoy_async_jobs if controller.present?

        DesignAfterDownloadWorker.perform_async(design.id,
                                                current_user.id,
                                                ahoy.visit_token)
      end

      def perform
        ::AhoyEventService.new(current_user: current_user,
                               event_name: event_name,
                               properties: event_properties,
                               visit_token: params[:visit_token]).track

        reload_design

        HourlyDownloadsCountService.new.execute_for_design(design)
      end

      private

      def event_name
        Ahoy::Event::DOWNLOADED_DESIGN
      end

      def event_properties
        { design_id: design.id }
      end

      def ahoy
        @ahoy ||= controller.present? ? controller.ahoy : service_ahoy
      end

      def service_ahoy
        ::Ahoy::Tracker.new(controller: nil, user: current_user)
      end

      def reload_design
        self.design = design.reload
      end
    end
  end
end
