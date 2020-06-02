# frozen_string_literal: true

module Designs
  module Downloads
    class CreateService < Designs::BaseService
      def execute
        design_download = Downloads::BuildService.new(design, params).execute

        design_download.save

        design_download
      end
    end
  end
end
