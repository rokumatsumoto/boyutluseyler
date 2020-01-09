FactoryBot.define do
  factory :identity do
    uid { "MyString" }
    provider { "MyString" }
    auth_data_dump { "MyText" }
    user { nil }
  end
end
