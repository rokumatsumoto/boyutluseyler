# frozen_string_literal: true

# Find Boyutluseyler user based on omniauth uid and provider
# Create new user from omniauth data
module Boyutluseyler
  module Auth
    module OAuth
      class User
        attr_accessor :auth_hash, :bs_user

        def initialize(auth_hash)
          self.auth_hash = auth_hash
          add_or_update_user_identities
        end

        def bs_user
          return @bs_user if defined?(@bs_user)

          @bs_user = find_user
        end

        def find_user
          user = find_by_uid_and_provider

          user ||= build_new_user

          user
        end

        protected

        def add_or_update_user_identities
          return unless bs_user

          # find_or_initialize_by doesn't update `bs_user.identities`, and isn't autosaved.
          identity = bs_user.identities.find { |identity| identity.provider == auth_hash.provider }

          identity ||= bs_user.identities.build(provider: auth_hash.provider)
          identity.uid = auth_hash.uid
        end

        def auth_hash=(auth_hash)
          @auth_hash = AuthHash.new(auth_hash)
        end

        def find_by_uid_and_provider
          identity = Identity.with_uid(auth_hash.provider, auth_hash.uid).take
          identity&.user
        end

        def build_new_user
          user_params = user_attributes.merge(skip_confirmation: true)
          Users::BuildService.new(nil, user_params).execute(skip_authorization: true)
        end

        def user_attributes
          username ||= auth_hash.username
          email ||= auth_hash.email
          {
            username: username,
            email: email,
            password: auth_hash.password,
            password_confirmation: auth_hash.password
          }
        end
      end
    end
  end
end
