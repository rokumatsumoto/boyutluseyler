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

require 'rails_helper'

RSpec.describe DesignIllustration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
