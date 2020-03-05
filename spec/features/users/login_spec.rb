require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
# rubocop:disable Metrics/BlockLength
# rubocop:disable RSpec/MultipleExpectations
RSpec.describe 'Login' do
  describe 'password reset token after successful sign in' do
    # rubocop:disable RSpec/ExampleLength
    it 'invalidates password reset token' do
      user = create(:user)

      expect(user.reset_password_token).to be_nil

      visit new_user_password_path
      fill_in 'user_email', with: user.email
      click_button 'btn_forgot_password'

      user.reload
      expect(user.reset_password_token).not_to be_nil

      boyutluseyler_sign_in(user)
      expect(page).to have_current_path root_path

      user.reload
      expect(user.reset_password_token).to be_nil
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'with correct username and password' do
    let(:user) { create(:user) }

    it 'allows basic login' do
      boyutluseyler_sign_in(user)

      expect(page).to have_css('a#user-dropdown')
      expect(page).to have_current_path root_path
    end
  end

  describe 'with invalid username and password' do
    let(:user) { create(:user, password: 'not-the-default') }

    it 'blocks invalid login' do
      boyutluseyler_sign_in(user)

      expect(page).to have_content(t('devise.failure.invalid'))
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/DescribeClass
