# frozen_string_literal: true

module Designs
  class CreateService < Designs::BaseService
    def execute
      design = BuildService.new(nil, current_user, params).execute

      success = design.save

      after_create(design) if success

      design
    end

    private

    def after_create(design)
      after_create_service(design).execute
    end

    def after_create_service(design)
      AfterCreateService.new(design, current_user, params)
    end
  end
end
