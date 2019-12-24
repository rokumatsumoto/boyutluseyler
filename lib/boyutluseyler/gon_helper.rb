# frozen_string_literal: true

module Boyutluseyler
  module GonHelper
    def add_gon_variables
      gon.websocket_server_url = Rails.application.config.websocket_server_url
      if current_user
        gon.current_user_id = current_user.id
        gon.current_username = current_user.username
      end
    end
  end
end
