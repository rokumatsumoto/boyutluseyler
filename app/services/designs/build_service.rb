# frozen_string_literal: true

module Designs
  class BuildService < Designs::BaseService
    def execute
      Design.new(params).tap do |d|
        d.user = current_user
      end
    end
  end
end
