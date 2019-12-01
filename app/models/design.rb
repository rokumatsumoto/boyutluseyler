# frozen_string_literal: true

# == Schema Information
#
# Table name: designs
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string(120)      not null
#  description            :text             not null
#  printing_settings      :text
#  model_file_format      :string
#  license_type           :string           not null
#  allow_comments         :boolean          default(TRUE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :bigint(8)        not null
#  category_id            :bigint(8)        not null
#  slug                   :string
#  downloads_count        :integer          default(0), not null
#  hourly_downloads_count :float            default(0.0), not null
#

class Design < ApplicationRecord
  extend FriendlyId

  include Taggable

  HOURLY_DOWNLOAD_CALCULATE_INTERVAL = 1.hour
  MOST_DOWNLOADED_LIMIT = 8

  has_many :design_illustrations, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :illustrations, through: :design_illustrations
  has_many :design_blueprints, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :blueprints, through: :design_blueprints

  # OPTIONAL
  # has_many :view_events, -> { where(name: 'Viewed design') }, class_name: "Ahoy::Event", foreign_store: :properties
  # has_many :download_events, -> { where(name: 'Downloaded design') }, class_name: "Ahoy::Event", foreign_store: :properties

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
  # TODO: create method for model extensions (stl|3ds|obj)
  def model_blueprints
    Blueprint.joins(:design_blueprint)
             .where(design_blueprints: { design_id: id })
             .where('url_path ~* ?', '.(stl|3ds|obj)$')
             .select(:url, :image_url)
             .order('design_blueprints.position')
  end

  # Class methods
  #
  class << self
    def most_downloaded
      includes(:taggings, :tags)
        .joins(:illustrations)
        .joins(:category)
        .where('downloads_count > ? AND designs.created_at < ? AND position = ?',
               0, Time.current - HOURLY_DOWNLOAD_CALCULATE_INTERVAL, 1)
        .select('designs.*, url, categories.slug as category_slug')
        .order(hourly_downloads_count: :desc, created_at: :desc)
        .limit(MOST_DOWNLOADED_LIMIT)
    end
  end
end
