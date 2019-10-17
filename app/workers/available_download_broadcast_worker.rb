# frozen_string_literal: true

class AvailableDownloadBroadcastWorker
  include ApplicationWorker

  def perform(design_id)
    design = Design.friendly.find(design_id)
    url = Designs::Files::DownloadService.new(design).execute
    # url = 'https://boyutluseyler-staging.s3.eu-central-1.amazonaws.com/uploads/design_zip/file/1/battle-cat-keychain-dual-extrusion20190927-cew1xdfv.zip'
    ActionCable.server.broadcast("download_channel_#{design.id}", url: url)
  end
end
