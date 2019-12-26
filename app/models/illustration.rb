# frozen_string_literal: true

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

class Illustration < ApplicationRecord
  include FileValidations

  has_one :design_illustration, inverse_of: :illustration
  has_one :design, through: :design_illustration

  #
  # Validations
  # FileValidations (concern)
  #

  validates :url_path, format: { with: /\.(png|jpg|jpeg|gif)\z/i }
end
