# frozen_string_literal: true

class IllustrationsController < ApplicationController
  include AWSS3UploaderHelper
  def create
    if illustration_params.key?(:key)
      obj = S3_BUCKET.object(illustration_params[:key])

      if obj.exists?
        # TODO: pundit
        @illustration = Illustration.new do |i|
          i.url = obj.public_url
          i.url_path = obj.key
          i.size = obj.size
          i.content_type = obj.content_type
          i.image_url = ''
        end

        if @illustration.save
          render json: { id: @illustration.id }, status: :created
        else
          render json: @illustration.errors.full_messages, status: :unprocessable_entity
        end

      else
        # TODO: not exists
        puts 'not exists'
      end
    end
  end

  private

  def illustration_params
    params.require(:illustration).permit(:key)
  end
end
