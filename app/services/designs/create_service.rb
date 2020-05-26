# frozen_string_literal: true

module Designs
  class CreateService < Designs::BaseService
    def execute
      design = BuildService.new(nil, current_user, params).execute

      before_create(design)

      success = design.save

      after_create(design) if success

      design
    end

    private

    def before_create(design)
      design.model_file_format = model_file_format_for(design)
    end

    def after_create(design)
      popularity_score_service_for_design(design).execute

      file_move_service_for_design(design).execute
    end

    def popularity_score_service_for_design(design)
      Designs::PageViews::PopularityScoreService.new(design)
    end

    def file_move_service_for_design(design)
      Designs::Files::MoveService.new(design, current_user, params)
    end
  end
end
