# frozen_string_literal: true

class DesignPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    true || is_admin?
  end

  def create?
    user || is_admin?
  end

  def new?
    user || is_admin?
  end

  def update?
    is_owner? || is_admin?
  end

  def edit?
    is_owner? || is_admin?
  end

  def destroy?
    is_owner? || is_admin?
  end

  def download?
    user || is_admin?
  end

  def like?
    user || is_admin?
  end

  def latest?
    true || is_admin?
  end

  def popular?
    true || is_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
