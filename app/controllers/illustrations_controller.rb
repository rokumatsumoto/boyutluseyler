# frozen_string_literal: true

class IllustrationsController < ApplicationController
  include AWSS3UploaderHelper
  def create
    if illustration_params.key?(:key)
      illustration_obj = S3_BUCKET.object(illustration_params[:key])

      if illustration_obj.exists?
        validate_content_type(:illustration, illustration_obj.key, illustration_obj.content_type)
        # TODO: pundit
        @illustration = Illustration.new do |i|
          i.url = illustration_obj.public_url
          i.url_path = illustration_obj.key
          i.size = illustration_obj.size
          i.content_type = @content_type
          i.image_url = ''
        end

        if @illustration.save
          render json: { id: @illustration.id }, status: :created
        else
          render json: @illustration.errors.full_messages, status: :unprocessable_entity
        end

      else
        # TODO:
        puts 'not exists'
      end
    end
  end

  private

  def illustration_params
    params.require(:illustration).permit(:key)
  end
end
