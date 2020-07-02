# frozen_string_literal: true

module Designs
  module Files
    class ListService < Designs::BaseService
      def initialize(opts = {})
        @design = opts[:design]
        @params = opts[:params]
        @action = opts[:action]
      end

      def execute
        design_files
      end

      private

      attr_reader :design, :params, :action

      def design_files
        {
          illustrations: illustration_list,
          blueprints: blueprint_list
        }
      end

      def illustration_list
        case action
        when :create_error, :update_error
          if array_empty?(params_illustration_ids)
            design.illustrations.reload
          else
            illustrations_with_no_relation
          end
        when :edit
          design.illustrations
        end
      end

      def blueprint_list
        case action
        when :create_error, :update_error
          if array_empty?(params_blueprint_ids)
            design.blueprints.reload
          else
            blueprints_with_no_relation
          end
        when :edit
          design.blueprints
        end
      end

      def illustrations_with_no_relation
        Illustration.left_outer_joins(:design_illustration)
                    .where(id: params_illustration_ids.map(&:to_i))
      end

      def blueprints_with_no_relation
        Blueprint.left_outer_joins(:design_blueprint)
                 .where(id: params_blueprint_ids.map(&:to_i))
      end
    end
  end
end
