# frozen_string_literal: true

module ValidatableFile
  extend ActiveSupport::Concern

  included do
    validates :url, presence: true
    validates :size, inclusion: { in: content_length_range }
    validates :content_type, presence: true
    validate :filename_is_blank

    before_validation :sanitize_attrs
    before_validation :ensure_content_type_correct
  end

  class_methods do
    def content_length_range
      # Default values needed for testing factories in rails console
      # For test env we use this `stub_sail_direct_upload_settings` method
      Range.new((Sail.get('direct_upload_content_length_range_min') || 1),
                (Sail.get('direct_upload_content_length_range_max') || 104_857_600))
    end
  end

  private

  def filename_is_blank
    # user input: '.stl', '.png', '  .zip'
    errors.add(:url_path, :blank) if filename.blank?
  end

  def sanitize_attrs
    # user input(XSS Svg payload): '"><svg onload=alert(1)>.jpg'
    %i[url url_path].each do |attr|
      value = self[attr]
      self[attr] = Sanitize.fragment(value) if value.present?
    end
  end

  def ensure_content_type_correct
    invalid = content_type.blank? || allowed_content_types.exclude?(content_type)

    self.content_type = content_type_by_filename(url_path) if invalid
  end

  def content_type_by_filename(filename)
    mime_info = MiniMime.lookup_by_filename(filename) if filename.present?

    return mime_info.content_type unless mime_info.nil?

    ''
  end

  def filename
    Boyutluseyler::FilenameHelpers.filename(url_path)
  end

  def allowed_content_types
    self.class::ALLOWED_CONTENT_TYPES
  end
end
