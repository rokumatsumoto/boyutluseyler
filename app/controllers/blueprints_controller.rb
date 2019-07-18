# frozen_string_literal: true

class BlueprintsController < ApplicationController
  include AWSS3UploaderHelper
  def create
    if blueprint_params.key?(:key)
      blueprint_obj = S3_BUCKET.object(blueprint_params[:key])

      if blueprint_obj.exists?
        validate_content_type(:blueprint, blueprint_obj.key, blueprint_obj.content_type)
        # TODO: pundit
        @blueprint = Blueprint.new do |i|
          i.url = blueprint_obj.public_url
          i.url_path = blueprint_obj.key
          i.size = blueprint_obj.size
          i.content_type = @content_type
          i.image_url = blueprint_obj.public_url
        end

        if @blueprint.save
          render json: { id: @blueprint.id }, status: :created
        else
          render json: @blueprint.errors.full_messages, status: :unprocessable_entity
        end

      else
        # TODO:
        puts 'not exists'
      end
    end
  end

  private

  def blueprint_params
    params.require(:blueprint).permit(:key)
  end
end
