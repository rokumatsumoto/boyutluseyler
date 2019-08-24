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

    def before_create(design)
      design.model_file_format = model_file_format_for(design)
    end

    def after_create(design)
      Designs::Files::MoveService.new(design, current_user, params).execute
    end
  end
end
