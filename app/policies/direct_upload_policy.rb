# frozen_string_literal: true

class DirectUploadPolicy < Struct.new(:user, :direct_upload)
  def initialize(*)
    super
    raise Pundit::NotAuthorizedError, reason: 'user.unauthenticated' unless user
  end

  def new?
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
