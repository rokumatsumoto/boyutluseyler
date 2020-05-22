# frozen_string_literal: true

class IllustrationsController < ApplicationController
  def create
    authorize Illustration

    result = create_service.new(ObjectStorage::DirectUpload::Bucket.new,
                                current_user,
                                illustration_params).execute

    if result[:status] == :success
      render json: { id: result[:illustration].id }, status: :created
    else
      render json: result[:message], status: result[:http_status]
    end
  rescue ArgumentError => e
    render json: e.message, status: :bad_request
  rescue Aws::S3::Errors::ServiceError => e
    render json: e.message, status: :internal_server_error
  end

  private

  def create_service
    Illustrations::CreateFromDirectUploadService
  end

  def illustration_params
    params.require(:illustration).permit(:key)
  end
end
