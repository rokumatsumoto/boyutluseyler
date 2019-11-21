# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id          :bigint(8)        not null, primary key
#  name        :string(50)       not null
#  description :text
#  list_order  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class Category < ApplicationRecord
  extend FriendlyId
  include Randomable

  has_many :designs

  friendly_id :name, use: %i[slugged history]

  def should_generate_new_friendly_id?
    name_changed?
  end
end
