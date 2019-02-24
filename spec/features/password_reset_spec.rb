require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Password reset' do
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

  def forgot_password(user, user_reload = true)
    visit new_user_session_path
    click_link 'link-forgot-your-password'
    fill_in 'user_email', with: user.email
    click_button 'btn_forgot_password'
    user.reload if user_reload
  end

  def not_found_message_for_email
    t('activerecord.errors.models.user.attributes.email.not_found')
  end
end
# rubocop:enable RSpec/DescribeClass
