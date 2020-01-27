# frozen_string_literal: true

class IdentityProviderPolicy < Struct.new(:user, :identity_provider)
  def initialize(*)
    super
    raise Pundit::NotAuthorizedError, reason: 'user.unauthenticated' unless user
  end

  def unlink?
    user || is_admin? # TODO: rolify
  end

  def link?
    user || is_admin? # TODO: rolify
  end

  private

  # Politely ask if the user has an admin role.
  #
  # @return [Boolean] Whether the current user has the admin role
  def is_admin? # rubocop:disable Style/PredicateName
    # user&.has_role?(:admin) # TODO: rolify
    false
  end
end
