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

require 'rails_helper'

RSpec.describe Blueprint, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
