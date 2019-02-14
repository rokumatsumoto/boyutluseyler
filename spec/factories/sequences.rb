FactoryBot.define do
  sequence(:username) { |n| "user#{n}" }
  sequence(:email) { |n| "user#{n}@example.org" }
end
