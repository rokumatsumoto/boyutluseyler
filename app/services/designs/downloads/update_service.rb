# frozen_string_literal: true

module Designs
  module Downloads
    class UpdateService < Designs::BaseService
      def execute(design_download)
        design_download.update(params)

        design_download
      end
    end
  end
end
