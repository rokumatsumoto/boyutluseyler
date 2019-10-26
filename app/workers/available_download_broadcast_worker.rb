# frozen_string_literal: true

class AvailableDownloadBroadcastWorker
  include ApplicationWorker

  attr_reader :design_id

  def perform(design_id)
    @design_id = design_id
    design = Design.find(design_id)

    before_download_service(design)

    url = Designs::Files::DownloadService.new(design).execute
    # url = 'uploads/design_zip/file/1/battle-cat-keychain-dual-extrusion20191026-hlozcrkj.zip'

    after_download_service(url)
  end

  def before_download_service(design)
    case step
    when 'file_updated', 'not_ready'
      move_next_step # requested

      update_design_download
    when 'ready', 'requested'
      return
    else
      Designs::Downloads::CreateService.new(design).execute
    end
  end

  def after_download_service(url)
    reload_design_download

    return perform(design_id) if file_updated?

    if url && url != ''
      move_next_step # ready

      update_design_download(url)

      broadcast(url, '')
    else
      move_initial_step # not_ready

      update_design_download

      # TODO: log, slack notification
      # TODO: i18n
      broadcast(
        '',
        'Sunucu kaynaklı bir problem oluştu, bir süre sonra tekrar deneyebilirsiniz.')
    end
  end

  def update_design_download(url = '')
    Designs::Downloads::UpdateService.new(nil, nil, url: url).execute(design_download)
  end

  def broadcast(url, message)
    ActionCable.server.broadcast("download_channel_#{design_id}",
                                 url: presigned_url(url),
                                 message: message)
  end

  def move_next_step
    design_download.set_step_as(design_download.next_step)
  end

  def move_initial_step
    design_download.set_step_as(design_download.initial_step)
  end

  def step
    return design_download.step if design_download

    nil
  end

  def file_updated?
    design_download.step == 'file_updated'
  end

  def presigned_url(url)
    Designs::Downloads::PresignedUrlService.new(nil, key: url).execute
  end

  def design_download
    @design_download ||= design_download_find_by
  end

  def reload_design_download
    @design_download = design_download_find_by
  end

  def design_download_find_by
    DesignDownload.find_by(design_id: design_id)
  end
end
