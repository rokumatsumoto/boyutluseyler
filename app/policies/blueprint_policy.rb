# frozen_string_literal: true

class BlueprintPolicy < ApplicationPolicy
  def create?
    user || is_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
