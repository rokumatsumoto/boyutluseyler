# == Schema Information
#
# Table name: design_illustrations
#
#  id              :bigint(8)        not null, primary key
#  design_id       :bigint(8)        not null
#  illustration_id :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  position        :integer
#

FactoryBot.define do
  factory :design_illustration do
    design_id { '' }
    illustration_id { '' }
  end
end
