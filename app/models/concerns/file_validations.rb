# frozen_string_literal: true

# Required fields
#  url          :string           not null
#  url_path     :string           not null
#  size         :integer          not null

module FileValidations
  extend ActiveSupport::Concern

  included do
    validate :filename_is_blank
    validates :url, presence: true
    validates :url_path, presence: true
    validates_inclusion_of :size, in: 1..104_857_600 # TODO: constants
    before_validation :sanitize_attrs
  end

  def filename_without_extension
    File.basename(url_path, '.*').split('.')[0]
  end

  def filename_is_blank
    # user input: '.stl', '.png', '  .zip'
    errors.add(:url_path, :blank) if filename_without_extension.blank?
  end

  def sanitize_attrs
    # user input: '"><svg onload=alert(1)>.jpg'
    %i[url url_path].each do |attr|
      value = self[attr]
      self[attr] = Sanitize.fragment(value) if value.present?
    end
  end
end
