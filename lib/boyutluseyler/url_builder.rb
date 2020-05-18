# frozen_string_literal: true

module Boyutluseyler
  class UrlBuilder
    attr_reader :object, :params

    def self.build(object, params = {})
      new(object, params).url
    end

    def url
      case object
      when Illustration, User, UserAvatar
        append_suffix_before_extension
      end
    end

    private

    def initialize(object, params)
      @object = object
      @params = params.dup
    end

    def append_suffix_before_extension
      filename = params[:url].delete_suffix(extension(params[:url]))
      filename << params[:suffix]
      filename << extension(params[:url])
    end

    def extension(url)
      ext = Boyutluseyler::FilenameHelper.extname(url)

      return '' if ext.blank?

      ext
    end
  end
end
