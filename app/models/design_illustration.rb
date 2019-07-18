# frozen_string_literal: true

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

class DesignIllustration < ApplicationRecord
  belongs_to :design
  belongs_to :illustration
  acts_as_list scope: :design
end
