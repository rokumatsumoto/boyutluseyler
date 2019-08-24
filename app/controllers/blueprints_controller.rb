# frozen_string_literal: true

class BlueprintsController < ApplicationController
  def create
    @blueprint = Blueprints::CreateService.new(blueprint_params).execute

    if @blueprint.persisted?
      render json: { id: @blueprint.id }, status: :created
    else
      render json: @blueprint.errors.full_messages, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: e.message, status: :bad_request
  rescue Aws::S3::Errors::ServiceError => e
    render json: e.message, status: :internal_server_error
  end

  private

  def blueprint_params
    params.require(:blueprint).permit(:key)
  end
end
