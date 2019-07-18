# frozen_string_literal: true

class FileUploadersController < ApplicationController
  include FileUploadersHelper
  include AWSS3UploaderHelper

  before_action :authenticate_user!

  def new
    if illustration?
      render_presigned_post(:illustration)
    elsif blueprint?
      render_presigned_post(:blueprint)
    end
  end
end
