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
  include BlocksJsonSerialization

  has_one :design_illustration, inverse_of: :illustration
  has_one :design, through: :design_illustration

  #
  # Validations
  #

  validates_format_of :url_path, with: /\.(png|jpg|jpeg|gif)\z/i
  # TODO: MOVE SHARED
  validate :filename_is_empty
  before_validation :sanitize_attrs

  def filename_is_empty
    # .png
    errors.add(:filename, :empty) if File.basename(url_path, '.*').split('.')[0] == ''
  end

  def sanitize_attrs
    # "><svg onload=alert(1)>.jpg
    %i[url url_path].each do |attr|
      value = self[attr]
      self[attr] = Sanitize.fragment(value) if value.present?
    end
  end
end
