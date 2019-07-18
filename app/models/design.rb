# frozen_string_literal: true

# == Schema Information
#
# Table name: designs
#
#  id                :bigint(8)        not null, primary key
#  name              :string(120)      not null
#  description       :text             not null
#  printing_settings :text
#  model_file_format :string
#  license_type      :string           not null
#  allow_comments    :boolean          default(TRUE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint(8)        not null
#  category_id       :bigint(8)        not null
#

class Design < ApplicationRecord
  Gutentag::ActiveRecord.call self

  has_many :design_illustrations, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :illustrations, through: :design_illustrations
  has_many :design_blueprints, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :blueprints, through: :design_blueprints

  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true
  validates :license_type, presence: true
  validates :category_id, presence: true
  validates :design_illustrations, presence: true
  validates :design_blueprints, presence: true

  enum license_type: {
    license_none: 'license_none',
    cc_by: 'cc_by',
    cc_by_sa: 'cc_by_sa',
    cc_by_nd: 'cc_by_nd',
    cc_by_nc: 'cc_by_nc',
    cc_by_nc_sa: 'cc_by_nc_sa',
    cc_by_nc_nd: 'cc_by_nc_nd'
  }

  # Return the tag names separated by a comma and space
  def tags_as_string
    tag_names.join(', ')
  end

  # Split up the provided value by commas and (optional) spaces.
  def tags_as_string=(string)
    self.tag_names = string.split(/,\s*/)
  end
end
