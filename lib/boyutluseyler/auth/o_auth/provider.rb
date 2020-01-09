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

        def self.providers
          Devise.omniauth_providers
        end

        def self.label_for(name)
          name = name.to_s

          LABELS[name] || name.titleize
        end
      end
    end
  end
end
