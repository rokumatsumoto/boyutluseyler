# frozen_string_literal: true

class BlueprintPolicy < ApplicationPolicy
  def create?
    user
  end
end
