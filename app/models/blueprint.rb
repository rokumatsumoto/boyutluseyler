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

  before_validation :set_preview

  PREVIEW_CONTENT_TYPES = %w[
    application/vnd.ms-pki.stl
    model/stl
    application/x-tgif
  ].freeze
  ALLOWED_EXTS = %w[stl obj zip].freeze

  # TODO: move to Boyutluseyler::Regex module
  # * Output: /.(stl|obj|zip)\z/i
  # * Test: https://rubular.com/r/3CdveqBY4b1mrK
  # * No escape characters
  # * No variables
  # * . Any single character
  # * a|b a or b
  # * \z End of string
  # * i Case insensitive
  ALLOWED_EXTS_REGEX = /.(#{ALLOWED_EXTS.join("|")})\z/i.freeze

  has_one :design_blueprint

  validates :url_path, format: { with: ALLOWED_EXTS_REGEX }

  private

  def set_preview
    return if content_type.nil?

    self.preview = PREVIEW_CONTENT_TYPES.include?(content_type)
  end
end
