# frozen_string_literal: true

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

class Blueprint < ApplicationRecord
  include FileValidations

  has_one :design_blueprint, inverse_of: :blueprint
  has_one :design, through: :design_blueprint

  #
  # Validations
  # FileValidations (concern)
  #

  # TODO: remove 3ds format, add ply format
  validates :url_path, format: { with: /\.(stl|3ds|obj|zip)\z/i }
end
