# == Schema Information
#
# Table name: designs
#
#  id                        :bigint(8)        not null, primary key
#  name                      :string(120)      not null
#  description               :text             not null
#  printing_settings         :text
#  model_file_format         :string
#  license_type              :string           not null
#  allow_comments            :boolean          default(TRUE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id                   :bigint(8)        not null
#  category_id               :bigint(8)        not null
#  slug                      :string
#  downloads_count           :integer          default(0), not null
#  hourly_downloads_count    :float            default(0.0), not null
#  popularity_score          :float            default(0.0), not null
#  home_popular_at           :datetime
#  likes_count               :integer          default(0), not null
#  hourly_downloads_count_at :datetime
#  cached_tag_names          :text
#

FactoryBot.define do
  factory :design do
    name { generate(:title) }
    description { Faker::Hipster.paragraph(sentence_count: 1)[0..100] }
    license_type { Design.license_types.keys[rand(1..6)] }

    # Transient Attributes
    transient do
      illustrations_count { 3 }
      blueprints_count { 3 }
      blueprint_preview { true }
    end

    # Associations
    user
    category

    # Callbacks
    before(:create) do |design, evaluator|
      design.illustrations = create_list(:illustration, evaluator.illustrations_count)

      design.blueprints = if evaluator.blueprint_preview
                            create_list(:blueprint, evaluator.blueprints_count)
                          else
                            create_list(:blueprint_no_preview, evaluator.blueprints_count)
                          end
    end

    # Traits
    trait :no_license do
      license_type { Design.license_types[:license_none] }
    end

    trait :comments_disabled do
      allow_comments { false }
    end

    trait :with_slug do
      slug { 'slug' }
    end
  end
end
