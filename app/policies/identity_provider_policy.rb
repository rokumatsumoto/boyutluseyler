# frozen_string_literal: true

class IdentityProviderPolicy < ApplicationPolicy
  def unlink?
    user || is_admin? # TODO: rolify
  end

  def link?
    user || is_admin? # TODO: rolify
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
