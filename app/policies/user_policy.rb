# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    user == record || is_admin? # TODO: rolify
  end

  def update?
    user == record || is_admin? # TODO: rolify
  end

  def exists?
    true
  end

  def reset?
    user == record || is_admin? # TODO: rolify
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
