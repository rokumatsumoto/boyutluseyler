# frozen_string_literal: true

module Designs
  class AfterCreateService < Designs::BaseService
    def execute
      return if design.blank? || params.blank?

      move_design_files
      set_design_download_step_to_not_ready
    end

    private

    def move_design_files
      Designs::Files::MoveService.new(design, current_user, params).execute
    end

    def set_design_download_step_to_not_ready
      Designs::Downloads::CreateService.new(design, current_user).execute
    end
  end
end
