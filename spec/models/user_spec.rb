require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  describe 'modules' do
    # rubocop:disable RSpec/ExampleLength
    it 'does include all required devise modules' do
      expect(described_class.devise_modules).to contain_exactly(:database_authenticatable,
                                                                :rememberable,
                                                                :recoverable,
                                                                :registerable,
                                                                :validatable,
                                                                :confirmable,
                                                                :lockable,
                                                                :trackable)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  it { is_expected.to have_accessor_attribute(:login) }
  it { is_expected.to have_accessor_attribute(:current_password) }

  describe 'validations' do
    subject(:user) { build_stubbed(:user) }

    describe 'username' do
      it 'validates presence' do
        expect(user).to validate_presence_of(:username)
      end

      # rubocop:disable RSpec/NestedGroups
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
      # rubocop:enable RSpec/NestedGroups

      # rubocop:disable RSpec/NestedGroups
      context 'when contains special characters' do
        it { is_expected.not_to allow_value('user@example.org').for(:username) }
        it { is_expected.not_to allow_value('new$user!username').for(:username) }
      end
      # rubocop:enable RSpec/NestedGroups

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

    it 'has a compatible email regex with Javascript' do
      expect(described_class.email_regexp).to eq(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
    end

    it_behaves_like 'an object with email-formated attributes', :email do
      subject { build_stubbed(:user) }
    end
  end

  describe '.find_for_database_authentication' do
    it 'strips whitespace from login' do
      user = create(:user)

      expect(described_class.find_for_database_authentication(login:
      " #{user.username} ")).to eq user
    end
  end

  def taken_message_for_username
    t('activerecord.errors.models.user.attributes.username.taken')
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
# rubocop:enable Metrics/BlockLength
