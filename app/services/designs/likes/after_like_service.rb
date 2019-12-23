# frozen_string_literal: true

module Designs
  module Likes
    class AfterLikeService
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

        DesignAfterLikeWorker.perform_async(design.id, current_user.id, ahoy.visit_token)
      end

      def perform
        return delete_like if liked?

        create_new_like
      end

      private

      def liked?
        Ahoy::Event.cached_any_events_for?(event_name, current_user, event_properties)
      end

      def delete_like
        Ahoy::Event.where(name: event_name, properties: event_properties, user_id: current_user.id).destroy_all
      end

      def create_new_like
        ::AhoyEventService.new(current_user: current_user,
                               event_name: event_name,
                               properties: event_properties,
                               visit_token: params[:visit_token]).track
      end

      def event_name
        Ahoy::Event::LIKED_DESIGN
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
    end
  end
end
