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
#  preview      :boolean          default(FALSE)
#

FactoryBot.define do
  factory :blueprint do
    url { 'https://example.com/blueprint.stl' }
    url_path { 'blueprint.stl' }
    size { 32_484 }
    content_type { 'application/vnd.ms-pki.stl' }
    preview { true }
  end

  factory :blueprint_no_preview, parent: :blueprint do
    url { 'https://example.com/blueprint.zip' }
    url_path { 'blueprint.zip' }
    content_type { 'application/zip' }
    preview { false }
  end
end
