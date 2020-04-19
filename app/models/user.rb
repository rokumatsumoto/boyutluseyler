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
#  external               :boolean          default(FALSE)
#

class User < ApplicationRecord
  include BlocksJsonSerialization

  rolify

  OMNIAUTH_PROVIDERS = %i[google_oauth2 facebook].freeze

  # TODO: move to Boyutluseyler::Regex module
  # TODO: https://github.com/presidentbeef/brakeman/wiki/How-to-Report-a-Brakeman-Issue#false-positivesfalse-negatives
  # * Output: /\A[a-zA-ZğüşıöçĞÜŞİÖÇ0-9]+(?:[._-][a-zA-ZğüşıöçĞÜŞİÖÇ0-9]+)*\z/
  # * Test: https://rubular.com/r/NVt4RvIc6c4ZEL
  USERNAME_REGEX =
    /
    \A                                 # start of string
    [a-zA-ZğüşıöçĞÜŞİÖÇ0-9]+           # one or more ASCII letters digits with TR characters support
    (?:[._-][a-zA-ZğüşıöçĞÜŞİÖÇ0-9]+)* # 0+ sequences of:
                                         # [._-] a . or _ or -
                                         # [a-zA-ZğüşıöçĞÜŞİÖÇ0-9]+ one or more ASCII letters digits
    \z                                 # end of string
    /x.freeze

  IMG_EXTS = %w[png jpg jpeg gif].freeze

  # TODO: move to Boyutluseyler::Regex module
  # * Output: /.(png|jpg|jpeg|gif)\z/i
  # * Test: https://rubular.com/r/zmGjZaI8J8QMFN
  # * No escape characters
  # * No variables
  # * . Any single character
  # * a|b a or b
  # * \z End of string
  # * i Case insensitive
  IMG_EXTS_REGEX = /.(#{IMG_EXTS.join("|")})\z/i.freeze

  # validatable adds validations for email and password
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :omniauthable, omniauth_providers: OMNIAUTH_PROVIDERS

  has_many :designs
  has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
  has_many :identities, dependent: :destroy, autosave: true
  has_many :users_roles, dependent: :destroy
  has_many :roles, through: :users_roles
  has_one :user_avatar, dependent: :destroy

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login
  # Add an accessor so you can have a field to validate that is seperate from
  # password, password_confirmation or password_digest...
  attr_accessor :current_password

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { in: 3..30 }, format: { with: USERNAME_REGEX }
  validates :password, confirmation: true
  validates :avatar_url, presence: true, format: { with: IMG_EXTS_REGEX }, on: :update
  validate :avatar_filename_is_blank, on: :update

  class << self
    # Devise method overridden to allow sign in with email or username
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      where(conditions).find_by('lower(username) = :value OR lower(email) =
                                 :value', value: login.downcase(:turkic).strip)
    end

    def find_by_username(username)
      find_by('lower(username) = :username', username: username.downcase(:turkic))
    end

    def clean_username(username)
      username = username.dup
      # Get the email username by removing everything after an `@` sign.
      username.gsub!(/@.*\z/, '')
      # Remove everything that's not in the list of allowed characters.
      username.gsub!(/[^a-zA-ZğüşıöçĞÜŞİÖÇ0-9_\-\.]/, '')
      # Remove trailing violations ('.', '_', '-)
      username.gsub!(/(\.|\_|\-)*\z/, '')
      # Remove leading violations ('.', '_', '-)
      username.gsub!(/\A(\.|\_|\-)*/, '')
      # Users with the great usernames of "." or ".." would end up with a blank username.
      # Work around that by setting their username to "blank", followed by a counter.
      username = 'blank' if username.blank?

      uniquify = Uniquify.new
      uniquify.string(username) { |s| find_by_username(s) } # rubocop:disable Rails/DynamicFindBy
    end
  end

  def recently_sent_password_reset?
    reset_password_sent_at.present? && reset_password_sent_at >= 1.minute.ago
  end

  def skip_confirmation=(bool)
    skip_confirmation! if bool
  end

  private

  def avatar_filename_is_blank
    # user input: '.png'
    filename = Boyutluseyler::FilenameHelpers.filename(avatar_url)

    errors.add(:avatar_url, :blank) if filename.blank?
  end
end
