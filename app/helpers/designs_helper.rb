# frozen_string_literal: true

module DesignsHelper
  def fetch_most_downloaded
    design_list = Rails.cache.fetch('most_downloaded',
                                    expires_in: Design::HOURLY_DOWNLOAD_CALCULATE_INTERVAL) do
      Designs::Downloads::HourlyDownloadsCountService.new.execute

      Design.most_downloaded.to_json
    end

    JSON.parse(design_list)
  end
end
