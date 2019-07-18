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
#  image_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Blueprint < ApplicationRecord
  has_one :design_blueprint, inverse_of: :blueprint
  has_one :design, through: :design_blueprint

  #
  # Validations
  #

  validates_format_of :url_path, with: /\.(stl|3ds|obj|zip)\z/i
  # TODO: MOVE SHARED
  validate :filename_is_empty
  before_validation :sanitize_attrs

  def filename_is_empty
    # .stl
    errors.add(:filename, :empty) if File.basename(url_path, '.*').split('.')[0] == ''
  end

  def filename
    File.basename(url_path)
  end

  def as_json(options = {})
    super(options).tap do |json|
      json[:filename] = filename
    end
  end

  def sanitize_attrs
    %i[url url_path].each do |attr|
      value = self[attr]
      self[attr] = Sanitize.fragment(value) if value.present?
    end
  end
end
