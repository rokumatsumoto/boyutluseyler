# frozen_string_literal: true

class DesignPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    true
  end

  def create?
    user
  end

  def update?
    is_owner? || is_admin?
  end

  def destroy?
    update?
  end

  def download?
    user
  end

  def like?
    user
  end

  def latest?
    true
  end

  def popular?
    true
  end
end
