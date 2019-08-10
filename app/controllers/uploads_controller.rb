# frozen_string_literal: true

class UploadsController < ApplicationController
  include UploadsActions

  UnknownUploadModelError = Class.new(StandardError)

  MODEL_CLASSES = {
    'blueprint' => Blueprint,
    'illustration' => Illustration
  }.freeze

  rescue_from UnknownUploadModelError, with: :render_404

  before_action :authenticate_user!
  before_action :find_model

  def find_model
    strong_memoize(:find_model) { upload_model_class }
  end

  def upload_model_class
    MODEL_CLASSES[upload_params[:model]] || raise(UnknownUploadModelError)
  end
end
