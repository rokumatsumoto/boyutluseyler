# frozen_string_literal: true

class AvailableDownloadBroadcastWorker
  include ApplicationWorker

  def perform(design_id)
    design = Design.friendly.find(design_id)
    Designs::Files::DownloadService.new(design).execute
  end


end
