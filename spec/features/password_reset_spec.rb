require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Password reset' do
  include PasswordResetHelpers
  describe 'throttling' do
    it 'sends reset instructions when not previously sent' do
      user = create(:user)
      forgot_password(user)

      expect(page).to have_content(t('devise.passwords.send_instructions'))
      expect(page).to have_current_path new_user_session_path
      expect(user).to be_recently_sent_password_reset
    end

    it 'sends reset instructions when previously sent more than a minute ago' do
      user = create(:user)
      user.send_reset_password_instructions
      user.update_attribute(:reset_password_sent_at, 5.minutes.ago)

      expect { forgot_password(user) }.to change(user, :reset_password_sent_at)
      expect(page).to have_content(t('devise.passwords.send_instructions'))
      expect(page).to have_current_path new_user_session_path
    end

    it 'throttles multiple resets in a short timespan' do
      user = create(:user)
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

    # rubocop:disable RSpec/MultipleExpectations
    it 'displays the errors' do
      forgot_password(unregistered_user, false) # user, user_reload = false

      expect(page).not_to have_current_path new_user_session_path
      expect(page).to have_content(not_found_message_for_email)
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'token' do
    context 'with valid token' do
      it 'renders change password page' do
        user = create(:user)

        render_change_password_with_valid_token(user)
      end
    end

    context 'with expired token' do
      let(:user) { create(:user) }

      before do
        token = user.send_reset_password_instructions
        user.update_attribute(:reset_password_sent_at, 3.days.ago)

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

      context 'with token expires while filling in the form' do
        before do
          render_change_password_with_valid_token(user)

          user.update_attribute(:reset_password_sent_at, 3.days.ago)

          change_password(user)
        end

        it 'redirects to forgot your password page' do
          expect(page).to have_content(expired_message_for_reset_password_token)
          expect(page).to have_current_path new_user_password_url(user_email: user['email'])
        end

        it 'fills email field on forgot your password page' do
          expect(page).to have_field('user_email', with: user.email)
        end
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
