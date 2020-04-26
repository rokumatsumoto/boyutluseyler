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
  include ValidatableFile

  # MIME types
  # png - image/png
  # gif - image/gif
  # jpeg jpg - image/jpeg

  ALLOWED_CONTENT_TYPES = %w[
    image/png
    image/gif
    image/jpeg
  ].freeze

  ALLOWED_EXTS = %w[png jpg jpeg gif].freeze

  # TODO: move to Boyutluseyler::Regex module
  # TODO: improve regex for app/javascript/connected_uploader/constants.js
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingMetadata.html
  # * Output: /.[.](png|jpg|jpeg|gif)\z/i
  # * Test: https://rubular.com/r/J9pG880I9WxJUP
  # * No escape characters
  # * No variables
  # * . Any single character
  # * [.] A single character of: .
  # * a|b a or b
  # * \z End of string
  # * i Case insensitive
  ALLOWED_EXTS_REGEX = /.[.](#{ALLOWED_EXTS.join("|")})\z/i.freeze

  has_one :design_illustration

  validates :url_path, format: { with: ALLOWED_EXTS_REGEX }
end
