# frozen_string_literal: true

module Designs
  module Downloads
    class HourlyDownloadsCountService
      attr_reader :design

      def execute
        design_list = Design.most_downloaded

        design_list.each do |design|
          execute_for_design(design)
        end
      end

      def execute_for_design(design)
        @design = design

        calculate_and_save
      end

      private

      def calculate_and_save
        design.update_attribute(:hourly_downloads_count, calculate)
      end

      def calculate
        downloads_count / ((time - created_at) / hourly)
      end

      def downloads_count
        design.downloads_count
      end

      def created_at
        design.created_at
      end

      def time
        Time.now
      end

      def hourly
        Design::HOURLY_DOWNLOAD_CALCULATE_INTERVAL
      end
    end
  end
end
