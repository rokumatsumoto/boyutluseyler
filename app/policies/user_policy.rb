# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    current_user? || is_admin?
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def reset?
    show?
  end

  private

  def current_user?
    user == record
  end
end
