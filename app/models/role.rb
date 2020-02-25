# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  resource_type :string
#  resource_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#


class Role < ApplicationRecord
  ROLES = %w[
    admin
  ].freeze

  # NOT_IMPLEMENTED_ROLES = %w[
  #   banned
  #   beta_tester
  #   comment_banned
  #   moderator
  #   trusted
  #   warned
  # ].freeze

  has_many :users_roles, dependent: :destroy
  has_many :users, through: :users_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true

  before_destroy :cancel

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  validates :name,
            inclusion: { in: ROLES }

  scopify

  private

  # Needed to ensure that removing all user from role doesn't remove role.
  def cancel
    throw(:abort)
  end
end
