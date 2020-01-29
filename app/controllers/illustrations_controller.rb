# frozen_string_literal: true

class IllustrationsController < ApplicationController
  def create
    authorize Illustration

    @illustration = Illustrations::CreateService.new(illustration_params).execute

    if @illustration.persisted?
      render json: { id: @illustration.id }, status: :created
    else
      render json: @illustration.errors.full_messages, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: e.message, status: :bad_request
  rescue Aws::S3::Errors::ServiceError => e
    render json: e.message, status: :internal_server_error
  end

  private

  def illustration_params
    params.require(:illustration).permit(:key)
  end
end
