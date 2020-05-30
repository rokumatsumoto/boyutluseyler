# frozen_string_literal: true

module Designs
  module Downloads
    class BuildService < Designs::BaseService
      def execute
        DesignDownload.new(params).tap do |design_download|
          design_download.design = design
        end
      end
    end
  end
end
