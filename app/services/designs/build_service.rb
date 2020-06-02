# frozen_string_literal: true

module Designs
  class BuildService < Designs::BaseService
    def execute
      Design.new(params).tap do |design|
        design.user = current_user
        design.model_file_format = model_file_format
      end
    end
  end
end
