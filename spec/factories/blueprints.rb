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
    url { 'https://example.com/blueprint.stl' }
    url_path { 'blueprint.stl' }
    size { 32_484 }
    content_type { 'application/vnd.ms-pki.stl' }
  end
end
