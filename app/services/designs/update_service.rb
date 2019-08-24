# frozen_string_literal: true

module Designs
  class UpdateService < Designs::BaseService
    def execute
      before_update

      design.update(params)

      Designs::Files::MoveService.new(design, current_user, params).execute

      design
    end

    def before_update
      design.model_file_format = model_file_format_for(design)
    end
  end
end
