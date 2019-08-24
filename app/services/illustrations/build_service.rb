# frozen_string_literal: true

module Illustrations
  class BuildService < Illustrations::BaseService
    def execute
      raise_no_such_key unless illustration_exists?

      Illustration.new.tap do |i|
        i.url = illustration.public_url
        i.url_path = illustration.key
        i.size = illustration.size
        i.content_type = illustration.content_type
        i.image_url = ''
      end
    end

    private

    def raise_no_such_key
      # TODO: log and i18n exception
      raise Aws::S3::Errors::NoSuchKey.new 'Error', 'Dosya bulunamadı, site
        yönetimiyle irtibata geçiniz.'
    end

    def illustration_exists?
      illustration.exists?
    end

    def illustration
      strong_memoize(:illustration) { bucket.object(params[:key]) }
    end

    def bucket
      DIRECT_UPLOAD_AWS_S3_BUCKET
    end
  end
end
