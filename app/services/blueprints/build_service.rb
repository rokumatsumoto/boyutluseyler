# frozen_string_literal: true

module Blueprints
  class BuildService < Blueprints::BaseService
    def execute
      return unless blueprint_exists?

      Blueprint.new.tap do |b|
        b.url = blueprint.public_url
        b.url_path = blueprint.key
        b.size = blueprint.size
        b.content_type = blueprint.content_type
        b.image_url = ''
      end
    end

    private

    def blueprint_exists?
      blueprint.exists?
    end

    def blueprint
      strong_memoize(:blueprint) { bucket.object(params[:key]) }
    end

    def bucket
      DIRECT_UPLOAD_AWS_S3_BUCKET
    end
  end
end
