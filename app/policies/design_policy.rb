# frozen_string_literal: true

class DesignPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    true || is_admin? # TODO: rolify
  end

  def create?
    user || is_admin? # TODO: rolify
  end

  def new?
    user || is_admin? # TODO: rolify
  end

  def update?
    is_owner? || is_admin? # TODO: rolify
  end

  def edit?
    is_owner? || is_admin? # TODO: rolify
  end

  def destroy?
    is_owner? || is_admin? # TODO: rolify
  end

  def download?
    user || is_admin? # TODO: rolify
  end

  def like?
    user || is_admin? # TODO: rolify
  end

  def latest?
    true || is_admin? # TODO: rolify
  end

  def popular?
    true || is_admin? # TODO: rolify
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
