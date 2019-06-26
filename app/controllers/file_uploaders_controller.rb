# frozen_string_literal: true

class FileUploadersController < ApplicationController
  include AWSS3UploaderHelper

  before_action :authenticate_user!

  def new
    if file_uploader_params.key?(:illustration) &&
       file_uploader_params[:illustration] == 'true'
      render_presigned_post(:illustration)
    elsif file_uploader_params.key?(:blueprint) &&
          file_uploader_params[:blueprint] == 'true'
      render_presigned_post(:blueprint)
    end
  end

  private

  def file_uploader_params
    params.permit(:illustration, :blueprint)
  end
end
