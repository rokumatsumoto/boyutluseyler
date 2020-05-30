# frozen_string_literal: true

module Designs
  class UpdateService < Designs::BaseService
    def execute
      before_update

      success = design.update(params)

      ensure_update(design)

      design
    end

    def before_update
      before_update_service.execute
    end

    def before_update_service
      BeforeUpdateService.new(design, current_user, params)
    end

    def ensure_update(design)
      # it must be executed whether update successful or not
      # for already saved files
      Designs::Files::MoveService.new(design, current_user, params).execute
    end
  end
end
