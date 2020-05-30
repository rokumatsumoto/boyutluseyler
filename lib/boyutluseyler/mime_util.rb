# frozen_string_literal: true

module Boyutluseyler
  module MimeUtil
    extend self

    def extension_by_content_type(content_type)
      MiniMime.lookup_by_content_type(content_type).extension
    end
  end
end
