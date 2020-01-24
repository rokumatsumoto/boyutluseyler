# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, reason: 'user.unauthenticated' unless user

    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # Politely ask if the user has an admin role for the record.  If your "scope"
  # for administration is not the record itself, you can manually specify the
  # scope as a parameter.
  #
  # @param [Object, Class, optional] scope The record or class you require the
  #   admin role on
  # @return [Boolean] Whether the current user has the admin role for the
  #   requested scope
  def is_admin?(_scope = record) # rubocop:disable Style/PredicateName
    # user&.has_role?(:admin, scope) # TODO: rolify
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
