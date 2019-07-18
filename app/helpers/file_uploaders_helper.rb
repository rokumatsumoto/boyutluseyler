# frozen_string_literal: true

module FileUploadersHelper
  # TODO: MOVE ALL
  def illustration?
    file_uploader_params.key?(:illustration) && file_uploader_params[:illustration] == 'true'
  end

  def blueprint?
    file_uploader_params.key?(:blueprint) && file_uploader_params[:blueprint] == 'true'
  end

  def file_uploader_params
    params.permit(:illustration, :blueprint)
  end
end
