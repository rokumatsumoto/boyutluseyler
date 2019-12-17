# frozen_string_literal: true

module Illustrations
  class BuildService < Illustrations::BaseService
    def execute
      raise_no_such_key unless illustration.exists?

      Illustration.new.tap do |i|
        i.url = public_url
        i.url_path = illustration.key
        i.size = illustration.size
        i.content_type = illustration.content_type
        i.large_url = url_for_size(:large)
        i.medium_url = url_for_size(:medium)
        i.thumb_url = url_for_size(:thumb)
      end
    end

    private

    def raise_no_such_key
      # TODO: log and i18n exception
      raise Aws::S3::Errors::NoSuchKey.new 'Error', 'Dosya bulunamadı, site
        yönetimiyle irtibata geçiniz.'
    end

    def illustration
      strong_memoize(:illustration) { bucket.object(params[:key]) }
    end

    def bucket
      DIRECT_UPLOAD_AWS_S3_BUCKET
    end

    def url_for_size(size)
      Boyutluseyler::UrlBuilder.build(Illustration.new,
                                      url: processed_public_url,
                                      suffix: "_#{size}")
    end

    def processed_public_url
      "#{Boyutluseyler.config[:direct_upload_processed_endpoint]}/#{illustration.key}"
    end

    def public_url
      "#{Boyutluseyler.config[:direct_upload_endpoint]}/#{illustration.key}"
    end
  end
end
