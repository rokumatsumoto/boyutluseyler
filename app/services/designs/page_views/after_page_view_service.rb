# frozen_string_literal: true

module Designs
  module PageViews
    class AfterPageViewService
      attr_reader :current_user, :controller, :params
      attr_accessor :design

      def initialize(design, user = nil, params = {})
        @design = design
        @current_user = user
        @controller = params.delete(:controller)
        @params = params.dup
      end

      def execute
        # TODO: Use AhoyEventService
        ahoy.track Ahoy::Event::VIEWED_DESIGN, design_id: design.id

        PopularityScoreService.new(design).execute
      end

      private

      # TODO: Create a module?
      def ahoy
        @ahoy ||= controller.present? ? controller.ahoy : service_ahoy
      end

      def service_ahoy
        ::Ahoy::Tracker.new(controller: nil, user: current_user)
      end
    end
  end
end
