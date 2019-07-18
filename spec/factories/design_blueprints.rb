# == Schema Information
#
# Table name: design_blueprints
#
#  id           :bigint(8)        not null, primary key
#  design_id    :bigint(8)        not null
#  blueprint_id :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  position     :integer
#

FactoryBot.define do
  factory :design_blueprint do
    design_id { '' }
    blueprint_id { '' }
  end
end
