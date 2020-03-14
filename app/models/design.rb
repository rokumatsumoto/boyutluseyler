# frozen_string_literal: true

# == Schema Information
#
# Table name: designs
#
#  id                        :bigint(8)        not null, primary key
#  name                      :string(120)      not null
#  description               :text             not null
#  printing_settings         :text
#  model_file_format         :string
#  license_type              :string           not null
#  allow_comments            :boolean          default(TRUE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id                   :bigint(8)        not null
#  category_id               :bigint(8)        not null
#  slug                      :string
#  downloads_count           :integer          default(0), not null
#  hourly_downloads_count    :float            default(0.0), not null
#  popularity_score          :float            default(0.0), not null
#  home_popular_at           :datetime
#  likes_count               :integer          default(0), not null
#  hourly_downloads_count_at :datetime
#

class Design < ApplicationRecord
  extend FriendlyId

  include Taggable
  include Sortable

  friendly_id :name, use: %i[slugged history]
  resourcify

  HOURLY_DOWNLOAD_INTERVAL = 1.hour
  POPULAR_INTERVAL = 1.hour
  MOST_DOWNLOADED_LIMIT = 8
  POPULAR_LIMIT = 12
  POPULARITY_EFFECT = 0.02

  has_many :design_illustrations, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :illustrations, through: :design_illustrations
  has_many :design_blueprints, -> { order(position: :asc) }, inverse_of: 'design'
  has_many :blueprints, through: :design_blueprints
  has_one :design_download, dependent: :destroy

  # OPTIONAL
  # has_many :view_events, -> { where(name: Ahoy::Event::VIEWED_DESIGN) },
  #          class_name: 'Ahoy::Event', foreign_store: :properties
  # has_many :download_events, -> { where(name: Ahoy::Event::DOWNLOADED_DESIGN) },
  #          class_name: 'Ahoy::Event', foreign_store: :properties

  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true
  validates :license_type, presence: true
  validates :category, presence: true
  validates :design_illustrations, presence: true
  validates :design_blueprints, presence: true

  scope :with_tags, -> { includes(:taggings, :tags) }
  scope :home_popular, -> { order(popularity_score: :desc).limit(POPULAR_LIMIT) }

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
  def preview_blueprints
    Blueprint.joins(:design_blueprint)
             .where(design_blueprints: { design_id: id })
             .where('url_path ~* ?', '.(stl|3ds|obj)$')
             .select(:url, :thumb_url)
             .order('design_blueprints.position')
  end

  def preview_illustrations
    illustrations.select(:id, :thumb_url, 'large_url as url')
  end

  # Class methods
  #
  class << self
    def sort_by_attribute(method)
      case method.to_s
      when 'downloads_count_desc' then reorder(downloads_count: :desc)
      when 'downloads_count_asc'  then reorder(downloads_count: :asc)
      when 'likes_count_desc'     then reorder(likes_count: :desc)
      when 'likes_count_asc'      then reorder(likes_count: :asc)
      when 'home_popular_at_desc' then reorder(home_popular_at: :desc)
      when 'home_popular_at_asc'  then reorder(home_popular_at: :asc)
      else order_by(method)
      end
    end

    def with_first_illustration
      joins(:illustrations).where('design_illustrations.position = ?', 1)
    end

    def with_illustrations
      with_tags
        .with_first_illustration
        .joins(:category)
        .select('designs.id, designs.name, designs.slug, illustrations.medium_url, categories.slug
                 as category_slug')
    end

    def most_downloaded
      where('downloads_count > :min_count AND  designs.created_at < :date',
            min_count: 0, date: Time.current - HOURLY_DOWNLOAD_INTERVAL)
        .order(hourly_downloads_count: :desc, created_at: :desc)
        .limit(MOST_DOWNLOADED_LIMIT)
    end

    def most_downloaded_with_illustrations
      with_illustrations.most_downloaded
    end

    def home_popular_with_illustrations
      with_illustrations
        .order(popularity_score: :desc)
        .limit(POPULAR_LIMIT)
    end

    def popular
      where.not(home_popular_at: nil)
    end

    def invalidate_most_downloaded_cache
      Rails.cache.delete('most_downloaded')
    end

    def invalidate_popular_designs_cache
      Rails.cache.delete('popular_designs')
    end
  end
end
