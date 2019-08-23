# frozen_string_literal: true

module Designs
  module Files
    class MoveService < Designs::BaseService
      def execute
        reorder_design_files
      end

      private

      def reorder_design_files
        reorder_illustrations
        reorder_blueprints
      end

      def reorder_illustrations
        return if illustration_ids_identical?(design)

        illustration_ids.each_with_index do |id, index|
          design.design_illustrations.where(illustration_id: id)
                .update_all(position: index + 1)
        end
      end

      def reorder_blueprints
        return if blueprint_ids_identical?(design)

        blueprint_ids.each_with_index do |id, index|
          design.design_blueprints.where(blueprint_id: id)
                .update_all(position: index + 1)
        end
      end
    end
  end
end
