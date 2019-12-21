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
        ahoy.track 'Viewed design', design_id: design.id

        PopularityScoreService.new(design).execute
      end

      private

      def ahoy
        @ahoy ||= controller.present? ? controller.ahoy : service_ahoy
      end

      def service_ahoy
        ::Ahoy::Tracker.new(controller: nil, user: current_user)
      end
    end
  end
end