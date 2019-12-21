# frozen_string_literal: true

module DesignsHelper
  def fetch_most_downloaded
    design_list = Rails.cache.fetch('most_downloaded',
                                    expires_in: Design::HOURLY_DOWNLOAD_CALCULATE_INTERVAL) do
      Designs::Downloads::HourlyDownloadsCountService.new.execute

      Design.most_downloaded_with_illustrations.to_json
    end

    JSON.parse(design_list)
  end

  def fetch_popular_designs
    design_list = Rails.cache.fetch('popular_designs', expires_in: 1.hour) do
      Designs::BecomePopularService.new.execute

      Design.home_popular_with_illustrations.to_json
    end

    JSON.parse(design_list)
  end
end
