# frozen_string_literal: true

class IllustrationPolicy < ApplicationPolicy
  def create?
    user
  end
end
