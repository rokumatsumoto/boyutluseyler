# frozen_string_literal: true

class BlueprintsController < ApplicationController
  def create
    return unless blueprint_params.key?(:key) # TODO: return 400 bad request

    @blueprint = Blueprints::CreateService.new(blueprint_params).execute

    if @blueprint.persisted?
      render json: { id: @blueprint.id }, status: :created
    else
      render json: @blueprint.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def blueprint_params
    params.require(:blueprint).permit(:key)
  end
end
