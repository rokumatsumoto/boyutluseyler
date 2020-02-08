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
    url { 'https://example.com/illustration.jpg' }
    url_path { 'illustration.jpg' }
    size { 35_029 }
    content_type { 'image/jpeg' }
    large_url { 'https://example.com/illustration_large.jpg' }
    medium_url { 'https://example.com/illustration_medium.jpg' }
    thumb_url { 'https://example.com/illustration_thumb.jpg' }
  end
end
