# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  events_count           :integer          default(0), not null
#  avatar_thumb_url       :string           default(""), not null
#  avatar_url             :string           default(""), not null
#  external               :boolean          default(FALSE)
#

FactoryBot.define do
  factory :user do
    email { generate(:email) }
    username { generate(:username) }
    password { '123456' }
    confirmed_at { Time.current }
    confirmation_token { nil }
    avatar_url { 'https://example.com/avatar_medium.png' }
    avatar_thumb_url { 'https://example.com/avatar_thumb.png' }

    # Traits
    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :locked do
      locked_at { Time.current }
    end
  end
end
