# frozen_string_literal: true

class IllustrationsController < ApplicationController
  def create
    return unless illustration_params.key?(:key) # TODO: return 400 bad request

    @illustration = Illustrations::CreateService.new(illustration_params).execute

    if @illustration.persisted?
      render json: { id: @illustration.id }, status: :created
    else
      render json: @illustration.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def illustration_params
    params.require(:illustration).permit(:key)
  end
end
