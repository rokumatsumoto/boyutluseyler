# frozen_string_literal: true

module Blueprints
  class BuildService < Blueprints::BaseService
    def execute
      raise_no_such_key unless blueprint.exists?

      Blueprint.new.tap do |b|
        b.url = public_url
        b.url_path = blueprint.key
        b.size = blueprint.size
        b.content_type = blueprint.content_type
        b.thumb_url = ''
      end
    end

    private

    def raise_no_such_key
      # TODO: log and i18n exception
      raise Aws::S3::Errors::NoSuchKey.new 'Error', 'Dosya bulunamadı, site
        yönetimiyle irtibata geçiniz.'
    end

    def blueprint
      strong_memoize(:blueprint) { bucket.object(params[:key]) }
    end

    def bucket
      DIRECT_UPLOAD_AWS_S3_BUCKET
    end

    def public_url
      "#{Boyutluseyler.config[:direct_upload_endpoint]}/#{blueprint.key}"
    end
  end
end
