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
#

FactoryBot.define do
  factory :category do
    name { 'MyString' }
    description { 'MyText' }
    list_order { 1 }
  end
end
