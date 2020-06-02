# == Schema Information
#
# Table name: categories
#
#  id          :bigint(8)        not null, primary key
#  name        :string(50)       not null
#  description :text
#  list_order  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

FactoryBot.define do
  factory :category do
    name { Faker::Name.name }

    # Traits
    trait :with_slug do
      slug { 'slug' }
    end
  end
end
