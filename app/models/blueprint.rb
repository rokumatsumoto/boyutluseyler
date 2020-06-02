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
#  preview      :boolean          default(FALSE)
#

class Blueprint < ApplicationRecord
  include ValidatableFile

  # MIME types
  # stl - application/vnd.ms-pki.stl, model/stl
  # obj - application/x-tgif
  # zip - application/zip

  PREVIEW_CONTENT_TYPES = %w[
    application/vnd.ms-pki.stl
    model/stl
    application/x-tgif
  ].freeze

  ALLOWED_CONTENT_TYPES = PREVIEW_CONTENT_TYPES + %w[
    application/zip
  ].freeze

  ALLOWED_EXTS = %w[stl obj zip].freeze

  # TODO: move to Boyutluseyler::Regex module
  # TODO: improve regex for app/javascript/connected_uploader/constants.js
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html
  # * Output: /.[.](stl|obj|zip)\z/i
  # * Test: https://rubular.com/r/qmK9fdGD3hbpjw
  # * No escape characters
  # * No variables
  # * . Any single character
  # * [.] A single character of: .
  # * a|b a or b
  # * \z End of string
  # * i Case insensitive
  ALLOWED_EXTS_REGEX = /.[.](#{ALLOWED_EXTS.join("|")})\z/i.freeze

  has_one :design_blueprint

  validates :url_path, format: { with: ALLOWED_EXTS_REGEX }

  before_validation :set_preview

  private

  def set_preview
    self.preview = PREVIEW_CONTENT_TYPES.include?(content_type)
  end
end
