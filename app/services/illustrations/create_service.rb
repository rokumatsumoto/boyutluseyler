# frozen_string_literal: true

module Illustrations
  class CreateService < Illustrations::BaseService
    def execute
      illustration = BuildService.new(params).execute

      illustration.save
      illustration
    end
  end
end
