# frozen_string_literal: true

module Boyutluseyler
  class UrlBuilder
    attr_reader :object, :params

    def self.build(object, params = {})
      new(object, params).url
    end

    def url
      case object
      when Illustration
        illustration_url
      end
    end

    private

    def initialize(object, params)
      @object = object
      @params = params.dup
    end

    def illustration_url
      filename = params[:url].delete_suffix(extension(params[:url]))
      filename << params[:suffix]
      filename << extension(params[:url])
    end

    def extension(url)
      Boyutluseyler::FilenameHelpers.extname(url)
    end
  end
end
