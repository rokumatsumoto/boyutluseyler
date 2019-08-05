class UploadsController < ApplicationController
  include UploadsHelper
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
