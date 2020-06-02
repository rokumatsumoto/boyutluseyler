# frozen_string_literal: true

class IdentityProviderPolicy < Struct.new(:user, :identity_provider)
  def initialize(*)
    super
    raise Pundit::NotAuthorizedError, reason: 'user.unauthenticated' unless user
  end

  def unlink?
    user
  end

  def link?
    user
  end
end
