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
          design_illustration = design.design_illustrations.find_by(illustration_id: id)

          design_illustration&.update_column(:position, index + 1)
        end
      end

      def reorder_blueprints
        return unless blueprints_changed?

        params_blueprint_ids.each_with_index do |id, index|
          design_blueprint = design.design_blueprints.find_by(blueprint_id: id)

          design_blueprint&.update_column(:position, index + 1)
        end
      end
    end
  end
end
