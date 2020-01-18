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

        def persisted?
          bs_user.try(:persisted?)
        end

        def valid?
          bs_user.try(:valid?)
        end

        def valid_sign_in?
          valid? && persisted?
        end

        def save(provider = 'OAuth')
          Users::UpdateService.new(bs_user, user: bs_user).execute!

          bs_user
        rescue ActiveRecord::RecordInvalid => e
          # TODO: log
          puts "(#{provider}) Error saving user #{auth_hash.uid} (#{auth_hash.email}): #{bs_user.errors.full_messages}"
        end

        def bs_user
          return @bs_user if defined?(@bs_user)

          @bs_user = find_user
        end

        def find_user
          user = find_by_uid_and_provider

          user ||= build_new_user

          user.external = true if user&.new_record?

          user
        end

        def find_and_update!
          save

          bs_user
        end

        protected

        def add_or_update_user_identities
          return unless bs_user

          # find_or_initialize_by doesn't update `bs_user.identities`, and isn't autosaved.
          identity = bs_user.identities.find { |identity| identity.provider == auth_hash.provider }

          identity ||= bs_user.identities.build(provider: auth_hash.provider)
          identity.uid = auth_hash.uid
          identity.auth_data_dump = auth_hash.auth_hash
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

          valid_username = ::User.clean_username(username)

          {
            username: valid_username,
            email: email,
            password: auth_hash.password,
            password_confirmation: auth_hash.password,
            avatar_url: medium_image_url,
            avatar_thumb_url: thumb_image_url
          }
        end

        def provider_module
          Boyutluseyler::Auth::OAuth::Provider
        end

        def medium_image_url
          provider_module.medium_image_url_for(auth_hash.provider, auth_hash.image)
        end

        def thumb_image_url
          provider_module.thumb_image_url_for(auth_hash.provider, auth_hash.image)
        end
      end
    end
  end
end
