# frozen_string_literal: true

module Designs
  module Downloads
    class HourlyDownloadsCountService
      attr_reader :design

      def execute
        design_list = Design.most_downloaded

        design_list.each do |design|
          @design = design

          calculate_and_save_for_list
        end
      end

      def execute_for_design(design)
        @design = design

        calculate_and_save
      end

      private

      def calculate_and_save
        design.update_column(:hourly_downloads_count, calculate)
      end

      def calculate_and_save_for_list
        design.update_columns(hourly_downloads_count: calculate,
                              hourly_downloads_count_at: Time.current)
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
        Time.current
      end

      def hourly
        Design::HOURLY_DOWNLOAD_INTERVAL
      end
    end
  end
end
