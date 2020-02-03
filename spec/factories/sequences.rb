FactoryBot.define do
  sequence(:username) { |n| "user#{n}" }
  sequence(:email)    { |n| "user#{n}@example.org" }
  sequence(:title)    { |n| "#{Faker::Book.title}#{n}" }
  sequence(:slug)     { |n| "slug-#{n}" }
end
