# frozen_string_literal: true

# == Schema Information
#
# Table name: design_blueprints
#
#  id           :bigint(8)        not null, primary key
#  design_id    :bigint(8)        not null
#  blueprint_id :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  position     :integer
#

class DesignBlueprint < ApplicationRecord
  belongs_to :design, inverse_of: :design_blueprints
  belongs_to :blueprint
  acts_as_list scope: :design
end
