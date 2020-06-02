# frozen_string_literal: true

class AvailableDownloadBroadcastWorker
  include ApplicationWorker

  attr_reader :design_id

  def perform(design_id)
    @design_id = design_id

    design = Design.find(design_id)

    before_download_service

    url = Designs::Files::DownloadService.new(design).execute
    # url = 'uploads/design_zip/file/1/battle-cat-keychain-dual-extrusion20191026-a985tfq3.zip'
    after_download_service(url)
  end

  private

  def before_download_service
    set_design_download_step_to_requested
  end

  def after_download_service(url)
    check_file_state

    if url && url != ''
      set_design_download_step_to_ready(url)

      broadcast(url, '')
    else
      set_design_download_step_to_initial_step

      broadcast( # TODO: i18n, log, slack notification
        '',
        'Sunucu kaynaklı bir problem oluştu, bir süre sonra tekrar deneyebilirsiniz.'
      )
    end
  end

  def set_design_download_step_to_requested
    design_download.set_step_as(:requested)

    update_design_download
  end

  def set_design_download_step_to_ready(url)
    design_download.set_step_as(:ready)

    update_design_download(url)
  end

  def set_design_download_step_to_initial_step
    design_download.set_step_as(design_download.initial_step)

    update_design_download
  end

  def check_file_state
    reload_design_download

    return perform(design_id) if file_updated?
  end

  def update_design_download(url = '')
    design_download_update_service(url).execute(design_download)
  end

  def broadcast(url, message)
    ActionCable.server.broadcast("download_channel_#{design_id}",
                                 url: presigned_url(url),
                                 message: message)
  end

  def file_updated?
    design_download.file_updated?
  end

  def presigned_url(url)
    Designs::Downloads::PresignedUrlService.new(nil, key: url).execute
  end

  def design_download_update_service(url)
    Designs::Downloads::UpdateService.new(nil, nil, url: url)
  end

  def design_download
    @design_download ||= DesignDownload.find_by(design_id: design_id)
  end

  def reload_design_download
    @design_download = design_download.reload
  end
end
