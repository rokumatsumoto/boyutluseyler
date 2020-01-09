# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  events_count           :integer          default(0), not null
#  avatar_thumb_url       :string           default(""), not null
#  avatar_url             :string           default(""), not null
#

class User < ApplicationRecord
  include BlocksJsonSerialization

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :omniauthable, omniauth_providers: %i[google_oauth2 facebook],
         email_regexp: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :designs
  has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
  has_many :identities, dependent: :destroy

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login
  # Add an accessor so you can have a field to validate
  # that is seperate from password, password_confirmation or
  # password_digest...
  attr_accessor :current_password
  # Validations
  #
  # Note: devise :validatable above adds validations for :email and :password

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { in: 3..30 }

  validates :password, confirmation: true
  # Only allow letter, number, underscore, hyphen and punctuation.
  validates :username,
            format: { with: /\A(?:[a-zA-ZğüşıöçĞÜŞİÖÇ0-9_\.][a-zA-ZğüşıöçĞÜŞİÖÇ0-9_\-\.]*[a-zA-ZğüşıöçĞÜŞİÖÇ0-9_\-]|[a-zA-ZğüşıöçĞÜŞİÖÇ0-9_])\z/ }
  validates :avatar_url, presence: true, on: :update
  validates :avatar_url, format: { with: /\.(png|jpg|jpeg|gif)\z/i }, on: :update
  validate :avatar_filename_is_blank, on: :update

  def avatar_filename_is_blank
    # user input: '.png'
    filename = Boyutluseyler::FilenameHelpers.filename(avatar_url)
    errors.add(:avatar_url, :blank) if filename.blank?
  end

  class << self
    # Devise method overridden to allow sign in with email or username
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      where(conditions).find_by('lower(username) = :value OR lower(email) =
                                 :value', value: login.downcase(:turkic).strip)
    end

    def avatar_content_length_range
      Range.new(1, 2_097_152)
    end
  end

  def recently_sent_password_reset?
    reset_password_sent_at.present? && reset_password_sent_at >= 1.minute.ago
  end
end
