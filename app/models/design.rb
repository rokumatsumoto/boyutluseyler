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
#  slug              :string
#

class Design < ApplicationRecord
  extend FriendlyId

  include Taggable

  has_many :design_illustrations, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :illustrations, through: :design_illustrations
  has_many :design_blueprints, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :blueprints, through: :design_blueprints
  has_one :design_downloads

  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true
  validates :license_type, presence: true
  validates :category_id, presence: true
  validates :design_illustrations, presence: true
  validates :design_blueprints, presence: true

  friendly_id :name, use: %i[slugged history]

  enum license_type: {
    license_none: 'license_none',
    cc_by: 'cc_by',
    cc_by_sa: 'cc_by_sa',
    cc_by_nd: 'cc_by_nd',
    cc_by_nc: 'cc_by_nc',
    cc_by_nc_sa: 'cc_by_nc_sa',
    cc_by_nc_nd: 'cc_by_nc_nd'
  }

  # TODO: add concern for friendlyid
  def should_generate_new_friendly_id?
    name_changed?
  end

  # TODO: remove 3ds format, add ply format
  def model_blueprints
    Blueprint.joins(:design_blueprint)
             .where(design_blueprints: { design_id: id })
             .where('url_path ~* ?', '.(stl|3ds|obj)$')
             .select(:url, :image_url)
             .order('design_blueprints.position')
  end
end
