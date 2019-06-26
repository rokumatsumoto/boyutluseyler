# frozen_string_literal: true

class IllustrationsController < ApplicationController
  def create
    if illustration_params.key?(:key)
      illustration_obj = S3_BUCKET.object(illustration_params[:key])

      if illustration_obj.exists?
        # TODO: pundit
        @illustration = Illustration.new do |i|
          i.url = illustration_obj.public_url
          i.url_path = illustration_obj.key
          i.size = illustration_obj.size
          i.content_type = illustration_obj.content_type
          i.image_url = illustration_obj.public_url
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
