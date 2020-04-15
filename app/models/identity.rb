# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id             :bigint(8)        not null, primary key
#  uid            :string
#  provider       :string
#  auth_data_dump :text
#  user_id        :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Identity < ApplicationRecord
  belongs_to :user

  serialize :auth_data_dump

  validates :provider, presence: true
  validates :uid, presence: true
  validates :user, uniqueness: { scope: :provider }

  scope :with_provider, ->(provider) { where(provider: provider) }
  scope :with_uid, ->(provider, uid) { where(uid: uid).with_provider(provider) }
end
