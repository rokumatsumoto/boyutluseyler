require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Devise password reset', tag: :devise_default do
  context 'with no errors' do
    it 'sends reset password instructions' do
      user = create(:user)
      forgot_password(user, false) # user, user_reload = false

      open_email(user.email)

      expect(current_email.subject).to eq t('devise.mailer.reset_password_instructions.subject')
    end
  end

  def forgot_password(user, user_reload = true)
    visit new_user_session_path
    click_link 'link-forgot-your-password'
    fill_in 'user_email', with: user.email
    click_button 'btn_forgot_password'
    user.reload if user_reload
  end
end
# rubocop:enable RSpec/DescribeClass
