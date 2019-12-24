# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.config.session_store :cookie_store, key: '_boyutluseyler_session'

Sidekiq::Web.set :sessions, domain: Boyutluseyler.config[:cookie_domain]
