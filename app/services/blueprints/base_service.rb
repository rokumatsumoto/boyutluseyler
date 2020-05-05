# frozen_string_literal: true

module Blueprints
  class BaseService < ::BaseService
    ValidationError = Class.new(StandardError)
  end
end
