# == Schema Information
#
# Table name: illustrations
#
#  id           :bigint(8)        not null, primary key
#  url          :string           not null
#  url_path     :string           not null
#  size         :integer          not null
#  content_type :string           not null
#  image_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Illustration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
