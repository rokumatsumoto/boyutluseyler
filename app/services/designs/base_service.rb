# frozen_string_literal: true

module Designs
  class BaseService
    include Boyutluseyler::FileFormat
    include Boyutluseyler::CollectionIdListHelper

    private

    attr_accessor :design, :current_user, :params

    def initialize(design, user = nil, params = {})
      @design = design
      @current_user = user
      @params = params.dup
    end

    def model_file_format
      file_format_for_collection_ids(params_blueprint_ids, Blueprint)
    end

    def blueprints_changed?
      return true if collection_ids_changed?(design.blueprint_ids.map(&:to_s),
                                             params_blueprint_ids)
    end

    alias model_file_format_changed? blueprints_changed?

    def params_blueprint_ids
      @params_blueprint_ids ||= (params[:blueprint_ids] || [])
    end

    def params_illustration_ids
      @params_illustration_ids ||= (params[:illustration_ids] || [])
    end
  end
end
