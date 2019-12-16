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
#  image_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
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

  # << REMOVE ON NEXT RELEASE (0.8.0)
  def thumb_url
    self.class.reset_column_information if self.class.column_names.include?('image_url')
    has_attribute?(:image_url) ? image_url : super
  end

  def thumb_url=(value)
    self.class.reset_column_information if self.class.column_names.include?('image_url')
    if has_attribute?(:image_url) && has_attribute?(:thumb_url)
      self[:image_url] = value
      return self[:thumb_url] = value
    end
    return self[:image_url] = value if has_attribute?(:image_url)

    super
  end
  # >> REMOVE ON NEXT RELEASE (0.8.0)
end
