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
        return unless illustrations_changed?

        params_illustration_ids.each_with_index do |id, index|
          design.design_illustrations.where(illustration_id: id)
                .update_all(position: index + 1)
        end
      end

      def reorder_blueprints
        return unless blueprints_changed?

        params_blueprint_ids.each_with_index do |id, index|
          design.design_blueprints.where(blueprint_id: id)
                .update_all(position: index + 1)
        end
      end

      def illustrations_changed?
        return true if collection_ids_changed?(design.illustration_ids.map(&:to_s),
                                               params_illustration_ids)
      end
    end
  end
end
