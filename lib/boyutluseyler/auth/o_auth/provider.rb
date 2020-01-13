# frozen_string_literal: true

module Boyutluseyler
  module Auth
    module OAuth
      class Provider
        LABELS = {
          'twitter' => 'Twitter',
          'google_oauth2' => 'Google',
          'facebook' => 'Facebook'
        }.freeze

        MEDIUM_IMAGE_URL_SUFFIX = {
          'twitter' => '',
          'google_oauth2' => '=s160-c',
          'facebook' => '?height=160&width=160'
        }.freeze

        THUMB_IMAGE_URL_SUFFIX = {
          'twitter' => '',
          'google_oauth2' => '=s36-c',
          'facebook' => '?height=36&width=36'
        }.freeze

        def self.providers
          Devise.omniauth_providers
        end

        def self.label_for(name)
          name = name.to_s

          LABELS[name] || name.titleize
        end

        def self.medium_image_url_for(name, url)
          "#{url}#{MEDIUM_IMAGE_URL_SUFFIX[name]}"
        end

        def self.thumb_image_url_for(name, url)
          "#{url}#{THUMB_IMAGE_URL_SUFFIX[name]}"
        end
      end
    end
  end
end
