# frozen_string_literal: true

module Blueprints
  class CreateService < Blueprints::BaseService
    def execute
      blueprint = BuildService.new(current_user, params).execute

      if blueprint.save
        success(blueprint: blueprint)
      else
        error(blueprint_save_error(blueprint), :unprocessable_entity)
      end
    rescue ValidationError => e
      error(e.message, :not_found)
    end

    private

    def blueprint_save_error(blueprint)
      blueprint.errors.full_messages.join(', ')
    end
  end
end
