require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
# rubocop:disable RSpec/MultipleExpectations
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Password reset' do
  include PasswordResetHelpers

  before do
    reset_password_within_two_days
  end

  describe 'throttling' do
    let(:user) { create(:user) }

    it 'sends reset instructions when not previously sent' do
      forgot_password(user)

      expect(page).to have_content(t('devise.passwords.send_instructions'))
      expect(page).to have_current_path new_user_session_path
      expect(user).to be_recently_sent_password_reset
    end

    it 'sends reset instructions when previously sent more than a minute ago' do
      user.send_reset_password_instructions
      user.update_attribute(:reset_password_sent_at, 5.minutes.ago)

      expect { forgot_password(user) }.to change(user, :reset_password_sent_at)
      expect(page).to have_content(t('devise.passwords.send_instructions'))
      expect(page).to have_current_path new_user_session_path
    end

    it 'throttles multiple resets in a short timespan' do
      user.send_reset_password_instructions
      # Reload because PG handles datetime less precisely than Ruby/Rails
      user.reload

      expect { forgot_password(user) }.not_to change(user, :reset_password_sent_at)
      expect(page).to have_content(t('devise.passwords.send_instructions'))
      expect(page).to have_current_path new_user_session_path
    end
  end

  context 'with errors' do
    let(:unregistered_user) { build_stubbed(:user) }

    it 'displays the errors' do
      forgot_password(unregistered_user, false) # user, user_reload = false

      expect(page).not_to have_current_path new_user_session_path
      expect(page).to have_content(not_found_message_for_email)
    end
  end

  describe 'token' do
    let(:user) { create(:user) }

    context 'with valid token' do
      it 'renders change password page' do
        render_change_password_with_valid_token(user)
      end
    end

    context 'with expired token' do
      before do
        token = user.send_reset_password_instructions
        user.update_attribute(:reset_password_sent_at, 2.days.ago)

        visit(edit_user_password_path(reset_password_token: token))
      end

      it 'redirects to forgot your password page' do
        expect(page).to have_current_path new_user_password_url(user_email: user['email'])
        expect(page).to have_content(expired_message_for_reset_password_token)
      end

      it 'fills email field on forgot your password page' do
        expect(page).to have_field('user_email', with: user.email)
      end
    end

    context 'with invalid token' do
      before do
        visit(edit_user_password_path(reset_password_token: 'invalid-token'))
      end

      it 'redirects to forgot your password page' do
        expect(page).to have_current_path new_user_password_url(user_email: '')
        expect(page).to have_content(invalid_message_for_reset_password_token)
      end

      it 'does not fill email field on forgot your password page' do
        expect(page).to have_field('user_email', with: '')
      end
    end
  end

  describe 'change your password' do
    context 'with valid token' do
      let(:user) { create(:user) }

      # rubocop:disable RSpec/NestedGroups
      context 'when the token expires while filling the form' do
        before do
          render_change_password_with_valid_token(user)

          user.update_attribute(:reset_password_sent_at, 2.days.ago)

          change_password(user)
        end

        it 'redirects to forgot your password page' do
          expect(page).to have_current_path new_user_password_url(user_email: user['email'])
          expect(page).to have_content(expired_message_for_reset_password_token)
        end

        it 'fills email field on forgot your password page' do
          expect(page).to have_field('user_email', with: user.email)
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable RSpec/DescribeClass
