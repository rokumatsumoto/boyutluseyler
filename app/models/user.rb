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
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         email_regexp: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

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
  validates_confirmation_of :password # override only: create
  # Only allow letter, number, underscore, hyphen and punctuation.
  validates_format_of :username,
                      with: /\A(?:[a-zA-Z0-9_\.][a-zA-Z0-9_\-\.]*[a-zA-Z0-9_\-]|[a-zA-Z0-9_])\z/

  class << self
    # Devise method overridden to allow sign in with email or username
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if (login = conditions.delete(:login))
        where(conditions).find_by('lower(username) = :value OR lower(email) =
                                   :value', value: login.downcase.strip)
      else
        find_by(conditions)
      end
    end
  end
end
