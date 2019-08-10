# frozen_string_literal: true

# Required fields
#  url          :string           not null
#  url_path     :string           not null
#  size         :integer          not null
#  content_type :string           not null

# Consider these methods
# allowed_content_types

module FileValidations
  extend ActiveSupport::Concern

  class_methods do
    def content_length_range
      Range.new(Sail.get('direct_upload_content_length_range_min'),
                Sail.get('direct_upload_content_length_range_max'))
    end
  end

  included do
    validate :filename_is_blank
    validates :url, presence: true
    validates :url_path, presence: true
    validates_inclusion_of :size, in: content_length_range
    before_validation :sanitize_attrs
    before_validation :ensure_content_type_correct
  end

  def filename_is_blank
    # user input: '.stl', '.png', '  .zip'
    errors.add(:url_path, :blank) if filename_without_extension.blank?
  end

  def filename_without_extension
    File.basename(url_path, '.*').split('.')[0]
  end

  def sanitize_attrs
    # user input: '"><svg onload=alert(1)>.jpg'
    %i[url url_path].each do |attr|
      value = self[attr]
      self[attr] = Sanitize.fragment(value) if value.present?
    end
  end

  def ensure_content_type_correct
    invalid = content_type.blank? || allowed_content_types.none?(content_type)

    self.content_type = content_type_by_filename(url_path) if invalid
  end

  def allowed_content_types
    case model_name.name
    when 'Illustration'
      %w[image/png image/gif image/jpeg]
    when 'Blueprint'
      %w[application/vnd.ms-pki.stl
         model/stl
         image/x-3ds
         application/x-tgif
         application/zip]
    else
      []
    end
  end

  def content_type_by_filename(filename)
    mime_info = MiniMime.lookup_by_filename(filename)

    return mime_info.content_type unless mime_info.nil?

    ''
  end
end
