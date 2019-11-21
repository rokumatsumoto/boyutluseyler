# frozen_string_literal: true

module Boyutluseyler
  module GonHelper
    def add_gon_variables
      gon.websocket_server_url = Rails.application.config.websocket_server_url
    end
  end
end
