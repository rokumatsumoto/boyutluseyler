# frozen_string_literal: true

module Designs
  module Downloads
    class BuildService < Designs::BaseService
      def execute
        DesignDownload.new(params).tap do |dd|
          dd.design = design
        end
      end
    end
  end
end
