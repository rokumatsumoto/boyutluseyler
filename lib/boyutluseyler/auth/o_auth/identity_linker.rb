# frozen_string_literal: true

module Boyutluseyler
  module Auth
    module OAuth
      class IdentityLinker
        attr_reader :current_user, :oauth

        def initialize(current_user, oauth)
          @current_user = current_user
          @oauth = oauth
          @changed = false
        end

        def link
          save if unlinked?
        end

        def changed?
          @changed
        end

        def failed?
          error_message.present?
        end

        def error_message
          identity.validate

          identity.errors.full_messages.join(', ')
        end

        private

        def save
          @changed = identity.save
        end

        def unlinked?
          identity.new_record?
        end

        def identity
          @identity ||= current_user.identities
                                    .with_uid(provider, uid)
                                    .first_or_initialize(uid: uid)
        end

        def provider
          oauth['provider']
        end

        def uid
          oauth['uid']
        end
      end
    end
  end
end
