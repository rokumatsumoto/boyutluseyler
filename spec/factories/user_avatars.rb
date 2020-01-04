FactoryBot.define do
  factory :user_avatar do
    letter_avatar_url { "MyString" }
    letter_avatar_thumb_url { "MyString" }
    user { nil }
  end
end
