# frozen_string_literal: true

module ObjectStorage
  module Concern
    extend ActiveSupport::Concern

    included do
      include Boyutluseyler::Utils::StrongMemoize
    end
  end
end
