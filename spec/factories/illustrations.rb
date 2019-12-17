# == Schema Information
#
# Table name: illustrations
#
#  id           :bigint(8)        not null, primary key
#  url          :string           not null
#  url_path     :string           not null
#  size         :integer          not null
#  content_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  large_url    :string           default(""), not null
#  medium_url   :string           default(""), not null
#  thumb_url    :string           default(""), not null
#

FactoryBot.define do
  factory :illustration do
    filename { 'MyString' }
    size { 1 }
    url { 'MyString' }
    url_path { 'MyString' }
    content_type { 'MyString' }
    thumb_url { 'MyString' }
  end
end
