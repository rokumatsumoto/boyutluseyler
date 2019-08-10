# rubocop:disable Naming/FileName
# frozen_string_literal: true

module Providers
  class AWS
    include Boyutluseyler::Utils::StrongMemoize

    def bucket
      nil
    end
  end
  # rubocop:enable Naming/FileName
end
