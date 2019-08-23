# frozen_string_literal: true

module Designs
  class BaseService
    include Boyutluseyler::Utils::StrongMemoize

    protected

    attr_accessor :design, :current_user, :params

    def initialize(design, user, params = {})
      @design = design
      @current_user = user
      @params = params.dup
    end

    def model_file_format_for(design)
      return if blueprint_ids_identical?(design)

      file_formats = Set.new
      blueprint_ids.each do |id|
        file_formats << MiniMime.lookup_by_content_type(Blueprint.find(id)
                                .content_type).extension.downcase
      end

      file_formats.to_a.join(', ')
    end

    def blueprint_ids_identical?(design)
      return true if blueprint_ids.all?(&:blank?)

      return true if !design.new_record? &&
                     design.blueprint_ids.map(&:to_s) == blueprint_ids
    end

    def illustration_ids_identical?(design)
      return true if illustration_ids.all?(&:blank?)

      return true if !design.new_record? &&
                     design.illustration_ids.map(&:to_s) == illustration_ids
    end

    def blueprint_ids
      params[:blueprint_ids]
    end

    def illustration_ids
      params[:illustration_ids]
    end
  end
end
