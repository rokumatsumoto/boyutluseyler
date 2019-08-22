# frozen_string_literal: true

module Blueprints
  class CreateService < Blueprints::BaseService
    def execute
      blueprint = BuildService.new(params).execute

      blueprint.save
      blueprint
    end
  end
end
