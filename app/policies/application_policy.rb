# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, reason: 'user.unauthenticated' unless user

    @user = user
    @record = record
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  # Politely ask if the user has an admin role for the record.  If your "scope"
  # for administration is not the record itself, you can manually specify the
  # scope as a parameter.
  #
  # @param [Object, Class, optional] scope The record or class you require the
  #   admin role on
  # @return [Boolean] Whether the current user has the admin role for the
  #   requested scope
  def is_admin?(scope = record) # rubocop:disable Style/PredicateName
    user&.has_role?(:admin, scope)
  end

  # Check the record.user association to see if it's owned by the current user.
  #
  # @return [Boolean] Whether the current user is the owner of the record
  def is_owner? # rubocop:disable Style/PredicateName
    return false unless user && record.respond_to?(:user)
    return false unless record.user_id == user.id
    return false if record.user_id_was && record.user_id_was != user.id

    true
  end
end
