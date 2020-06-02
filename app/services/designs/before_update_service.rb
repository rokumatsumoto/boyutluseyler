# frozen_string_literal: true

module Designs
  class BeforeUpdateService < Designs::BaseService
    def execute
      update_model_file_format
      set_design_download_step_to_file_updated
    end

    private

    def update_model_file_format
      return unless model_file_format_changed?

      design.model_file_format = model_file_format
    end

    def set_design_download_step_to_file_updated
      return unless blueprints_changed?

      design_download.set_step_as(:file_updated)

      design_download_update_service.execute(design_download)
    end

    def blueprints_changed?
      return false if collection_ids_match?(design.blueprint_ids.map(&:to_s), params_blueprint_ids)

      true
    end

    def design_download
      @design_download ||= design.design_download
    end

    def design_download_update_service
      Designs::Downloads::UpdateService.new(design, current_user, design_download_params)
    end

    def design_download_params
      {
        url: ''
      }
    end
  end
end
