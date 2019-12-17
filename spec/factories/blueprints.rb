# == Schema Information
#
# Table name: blueprints
#
#  id           :bigint(8)        not null, primary key
#  url          :string           not null
#  url_path     :string           not null
#  size         :integer          not null
#  content_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  thumb_url    :string           default(""), not null
#

FactoryBot.define do
  factory :blueprint do
    url { 'MyString' }
    url_path { 'MyString' }
    size { 1 }
    content_type { 'MyString' }
    thumb_url { 'MyString' }
  end
end
