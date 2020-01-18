# frozen_string_literal: true

module Boyutluseyler
  module Utils
    extend self

    def force_utf8(str)
      str.force_encoding(Encoding::UTF_8)
    end
  end
end
