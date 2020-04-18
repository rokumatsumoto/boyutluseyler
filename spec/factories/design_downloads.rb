# == Schema Information
#
# Table name: design_downloads
#
#  id         :bigint(8)        not null, primary key
#  step       :string(50)       not null
#  url        :string
#  design_id  :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :design_download do

    # Associations
    design
  end
end
