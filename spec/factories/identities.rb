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

FactoryBot.define do
  factory :identity do
    uid { '123456' }
    provider { 'twitter' }
  end
end
