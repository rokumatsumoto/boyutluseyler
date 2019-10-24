# frozen_string_literal: true

module Designs
  class UpdateService < Designs::BaseService
    def execute
      before_update

      success = design.update(params)

      after_update if success

      # it must be executed whether update successful or not
      # for already saved files
      Designs::Files::MoveService.new(design, current_user, params).execute

      design
    end

    def before_update
      design.model_file_format = model_file_format_for(design)

      if blueprints_changed?
        design_download.set_step_as(:file_updated)
      end
    end

    def after_update
      if blueprints_changed?
        Designs::Downloads::UpdateService.new(nil, nil, url: '').execute(design_download)
      end
    end

    def blueprints_changed?
      @blueprints_changed ||= !blueprint_ids_identical?(design)
    end

    def design_download
      @design_download ||= DesignDownload.find_by(design_id: design.id)
    end
  end
end
