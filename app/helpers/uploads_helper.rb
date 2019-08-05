# frozen_string_literal: true

module UploadsHelper
  # TODO: MOVE ALL
  def illustration?
    upload_params.key?(:illustration) && upload_params[:illustration] == 'true'
  end

  def blueprint?
    upload_params.key?(:blueprint) && upload_params[:blueprint] == 'true'
  end

  def upload_params
    params.permit(:illustration, :blueprint)
  end
end
