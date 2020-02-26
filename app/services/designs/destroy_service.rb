# frozen_string_literal: true

module Designs
  class DestroyService < Designs::BaseService
    # TODO: soft delete by request via form + slack integration
    def execute
      before_destroy

      success = design.destroy

      after_destroy if success
    end

    private

    def before_destroy
      create_temp_design
    end

    def after_destroy
      invalidate_caches
    end

    def invalidate_caches
      Design.invalidate_most_downloaded_cache if in_most_downloaded_cache_list?

      Design.invalidate_popular_designs_cache if in_popular_designs_cache_list?
    end

    def in_most_downloaded_cache_list?
      return false if temp_design.hourly_downloads_count_at.nil?

      temp_design.hourly_downloads_count_at >= Time.current - Design::HOURLY_DOWNLOAD_INTERVAL
    end

    def in_popular_designs_cache_list?
      return false if temp_design.home_popular_at.nil?

      temp_design.home_popular_at >= Time.current - Design::POPULAR_INTERVAL
    end

    def create_temp_design
      temp_design
    end

    def temp_design
      @temp_design ||= design
    end
  end
end
