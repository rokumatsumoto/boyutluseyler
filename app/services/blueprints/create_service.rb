# frozen_string_literal: true

module Blueprints
  class CreateService < Blueprints::BaseService
    def execute
      blueprint = BuildService.new(current_user, params).execute

      blueprint.save
      blueprint
    end
  end
end
