# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint(8)        not null, primary key
#  visit_id   :bigint(8)
#  user_id    :bigint(8)
#  name       :string
#  properties :jsonb
#  time       :datetime
#

FactoryBot.define do
  factory :ahoy_event, class: 'Ahoy::Event' do
    # Associations
    association :visit, factory: :ahoy_visit

    # Traits
    trait :liked_design do
      name { 'Liked design' }
    end

    trait :downloaded_design do
      name { 'Downloaded design' }
    end
  end
end
