# frozen_string_literal: true

module Boyutluseyler
  module Auth
    module OAuth
      class AuthHash
        attr_reader :auth_hash

        def initialize(auth_hash)
          @auth_hash = auth_hash
        end

        def uid
          @uid ||= Boyutluseyler::Utils.force_utf8(auth_hash.uid.to_s)
        end

        def provider
          @provider ||= auth_hash.provider.to_s
        end

        def username
          @username ||= username_and_email[:username].to_s
        end

        def email
          @email ||= username_and_email[:email].to_s
        end

        def password
          @password ||= Boyutluseyler::Utils.force_utf8(Devise.friendly_token[0, 8].downcase)
        end

        private

        def info
          auth_hash.info
        end

        def get_info(key)
          value = info[key]
          Boyutluseyler::Utils.force_utf8(value) if value
          value
        end

        def username_and_email
          @username_and_email ||= begin
            username  = get_info(:username).presence || get_info(:nickname).presence
            email     = get_info(:email).presence

            username ||= generate_username(email)             if email
            email    ||= generate_temporarily_email(username) if username

            {
              username: username,
              email:    email
            }
          end
        end

        # Get the first part of the email address (before @)
        # In addition in removes illegal characters
        def generate_username(email)
          email.match(/^[^@]*/)[0].mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/, '').to_s
        end

        def generate_temporarily_email(username)
          "temp-email-for-oauth-#{username}@boyutluseyler.localhost"
        end
      end
    end
  end
end
