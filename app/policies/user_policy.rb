# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    current_user? || is_admin? # TODO: rolify
  end

  def edit?
    current_user? || is_admin? # TODO: rolify
  end

  def update?
    current_user? || is_admin? # TODO: rolify
  end

  def reset?
    current_user? || is_admin? # TODO: rolify
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def current_user?
    user == record
  end
end
