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

require 'spec_helper'
RSpec.describe User, type: :model do
  describe 'modules' do
    it { is_expected.to include_module(BlocksJsonSerialization) }
    it { is_expected.to include_module(Rolify::Role) }

    context 'for Devise config' do
      it 'does include all required devise modules' do
        devise_modules = %i[database_authenticatable registerable recoverable rememberable
                            validatable confirmable lockable trackable omniauthable]

        expect(described_class.devise_modules).to match_array(devise_modules)
      end

      it 'uses given OmniAuth strategies' do
        expect(described_class.omniauth_providers).to eq(described_class::OMNIAUTH_PROVIDERS)
      end

      it 'has a compatible email regex with Javascript' do
        email_regexp = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

        expect(described_class.email_regexp).to eq(email_regexp)
      end
    end
  end

  describe 'constants' do
    subject { described_class }

    let(:omniauth_providers) { %i[google_oauth2 facebook] }
    let(:image_extensions) { %w[png jpg jpeg gif] }

    it { is_expected.to have_constant(:OMNIAUTH_PROVIDERS, Array).with_value(omniauth_providers) }
    it { is_expected.to have_constant(:USERNAME_REGEX, Regexp) }
    it { is_expected.to have_constant(:IMG_EXTS, Array).with_value(image_extensions) }
    it { is_expected.to have_constant(:IMG_EXTS_REGEX, Regexp) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:designs) }
    it { is_expected.to have_many(:events).class_name('Ahoy::Event').dependent(:destroy) }
    it { is_expected.to have_many(:identities).dependent(:destroy).autosave(true) }
    it { is_expected.to have_many(:users_roles).dependent(:destroy) }
    it { is_expected.to have_many(:roles).through(:users_roles) }
    it { is_expected.to have_one(:user_avatar).dependent(:destroy) }
  end

  it { is_expected.to have_accessor_attribute(:login) }
  it { is_expected.to have_accessor_attribute(:current_password) }

  describe 'validations' do
    subject(:user) { build_stubbed(:user) }

    describe 'username' do
      it 'validates presence' do
        expect(user).to validate_presence_of(:username)
      end
      context 'when in use by another user' do
        let(:username) { 'foo' }

        before { create(:user, username: username) }

        it 'is invalid' do
          user = build_stubbed(:user, username: username)

          expect(user).to validate_uniqueness_of(:username).case_insensitive
                                                           .with_message(taken_message_for_username)
        end

        it 'is invalid even if the casing is different' do
          user = build_stubbed(:user, username: username.capitalize)

          expect(user).to validate_uniqueness_of(:username).case_insensitive
                                                           .with_message(taken_message_for_username)
        end
      end

      context 'when contains ASCII letters / digits' do
        it { is_expected.to allow_value('Username').for(:username) }
        it { is_expected.to allow_value('username1').for(:username) }
      end

      context 'when contains Turkish characters' do
        it { is_expected.to allow_value('İmamBayıldı').for(:username) }
        it { is_expected.to allow_value('fıstıkçı-şahap').for(:username) }
        it { is_expected.to allow_value('çağatay.börülce').for(:username) }
      end

      context 'when contains punctuation marks (in English grammar and computing)' do
        it { is_expected.to allow_value('user_name').for(:username) }
        it { is_expected.to allow_value('user.name').for(:username) }
        it { is_expected.to allow_value('user-name').for(:username) }

        it { is_expected.not_to allow_value('user__name').for(:username) }
        it { is_expected.not_to allow_value('.username').for(:username) }
        it { is_expected.not_to allow_value('username_').for(:username) }
      end

      context 'when contains special characters' do
        it { is_expected.not_to allow_value('user@example.org').for(:username) }
        it { is_expected.not_to allow_value('new$user!username').for(:username) }
      end

      it 'validates minimum length' do
        expect(user).to validate_length_of(:username)
          .is_at_least(3).with_short_message(too_short_message_for_username)
      end

      it 'validates maximum length' do
        expect(user).to validate_length_of(:username)
          .is_at_most(30).with_long_message(too_long_message_for_username)
      end
    end

    it 'validates confirmation of password' do
      expect(user).to validate_confirmation_of(:password).with_message(
        confirmation_message_for_password
      )
    end

    describe 'avatar_url' do
      it { is_expected.to validate_presence_of(:avatar_url).on(:update) }

      context 'when contains allowed image extensions' do
        it { is_expected.to allow_value('http://foo.com/img.png').for(:avatar_url).on(:update) }
        it { is_expected.to allow_value('http://foo.com/img.jpg').for(:avatar_url).on(:update) }
        it { is_expected.to allow_value('http://foo.com/img.jpeg').for(:avatar_url).on(:update) }
        it { is_expected.to allow_value('http://foo.com/img.gif').for(:avatar_url).on(:update) }
      end

      context 'when contains not allowed file extensions' do
        it { is_expected.not_to allow_value('http://foo.com/img.pdf').for(:avatar_url).on(:update) }
        it { is_expected.not_to allow_value('http://foo.com/img.psd').for(:avatar_url).on(:update) }
      end

      context 'when filename is blank on update' do
        let!(:user) { create(:user) }

        it 'shows an error message' do
          user.update(avatar_url: '.png')

          expect(user.errors.full_messages.first).to eq(blank_message_for_avatar_url)
        end
      end
    end

    it_behaves_like 'an object with email-formatted attributes', :email do
      subject { build_stubbed(:user) }
    end
  end

  describe '.find_for_database_authentication' do
    it 'strips whitespace from login' do
      user = create(:user)

      expect(described_class.find_for_database_authentication(login:
      " #{user.username} ")).to eq user
    end

    it 'supports Turkish characters' do
      user = create(:user, username: 'İçel')

      expect(described_class.find_for_database_authentication(login: user.username)).to eq user
    end
  end

  describe '.clean_username' do
    before do
      create(:user, username: 'sametboyutluseyler-etc')
      create(:user, username: 'sametboyutluseyler-etc1')
    end

    it "cleans the username and makes sure it's available" do
      expect(described_class.clean_username('-samet+boyutluseyler-ETC%.@gmail.com')).to eq('sametboyutluseyler-ETC2')
      expect(described_class.clean_username('--_.%+--geçerli_*&%isim=._-@email.com')).to eq('geçerli_isim')
      # "geçerli isim" means "valid name" in English
    end
  end

  describe '#recently_sent_password_reset?' do
    it 'is false when reset_password_sent_at is nil' do
      user = build_stubbed(:user, reset_password_sent_at: nil)

      expect(user.recently_sent_password_reset?).to eq false
    end

    it 'is false when sent more than one minute ago' do
      user = build_stubbed(:user, reset_password_sent_at: 5.minutes.ago)

      expect(user.recently_sent_password_reset?).to eq false
    end

    it 'is true when sent less than one minute ago' do
      user = build_stubbed(:user, reset_password_sent_at: Time.current)

      expect(user.recently_sent_password_reset?).to eq true
    end
  end

  def taken_message_for_username
    t('activerecord.errors.models.user.attributes.username.taken')
  end

  def blank_message_for_avatar_url
    t('activerecord.errors.models.user.attributes.avatar_url.blank')
  end

  def too_short_message_for_username
    t('errors.messages.too_short.other', count: 3)
  end

  def too_long_message_for_username
    t('errors.messages.too_long.other', count: 30)
  end

  def confirmation_message_for_password
    t('errors.messages.confirmation', attribute:
    t('activerecord.attributes.user.password'))
  end
end
