# frozen_string_literal: true

module Designs
  module Downloads
    class CreateService < Designs::BaseService
      def execute
        design_download = BuildService.new(design, params).execute

        design_download.set_step_as(design_download.next_step) # :requested

        design_download.save

        design_download
      end
    end
  end
end
