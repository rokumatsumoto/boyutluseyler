class DownloadChannel < ApplicationCable::Channel
  def subscribed
    stream_from "download_channel_#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
