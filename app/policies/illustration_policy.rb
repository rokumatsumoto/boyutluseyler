# frozen_string_literal: true

class IllustrationPolicy < ApplicationPolicy
  def create?
    user || is_admin? # TODO: rolify
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
