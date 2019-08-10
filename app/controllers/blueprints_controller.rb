# frozen_string_literal: true

class BlueprintsController < ApplicationController
  def create
    if blueprint_params.key?(:key)
      obj = DIRECT_UPLOAD_AWS_S3_BUCKET.object(blueprint_params[:key])

      if obj.exists?
        # TODO: pundit
        @blueprint = Blueprint.new do |b|
          b.url = obj.public_url
          b.url_path = obj.key
          b.size = obj.size
          b.content_type = obj.content_type
          b.image_url = ''
        end

        if @blueprint.save
          render json: { id: @blueprint.id }, status: :created
        else
          render json: @blueprint.errors.full_messages, status: :unprocessable_entity
        end

      else
        # TODO: not exists
        puts 'not exists'
      end
    end
  end

  private

  def blueprint_params
    params.require(:blueprint).permit(:key)
  end
end
