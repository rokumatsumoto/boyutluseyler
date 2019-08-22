# frozen_string_literal: true

module Illustrations
  class BaseService
    include Boyutluseyler::Utils::StrongMemoize

    protected

    attr_accessor :params

    def initialize(params = {})
      @params = params.dup
    end
  end
end
