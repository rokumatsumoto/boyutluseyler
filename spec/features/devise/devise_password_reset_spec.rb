require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Devise password reset', tag: :devise_default do
  include PasswordResetHelpers
  context 'with no errors' do
    it 'sends reset password instructions' do
      user = create(:user)
      forgot_password(user, false) # user, user_reload = false

      open_email(user.email)

      expect(current_email.subject).to eq t('devise.mailer.reset_password_instructions.subject')
    end
  end

  describe 'change your password' do
    context 'with valid token' do
      let(:user) { create(:user) }

      before do
        render_change_password_with_valid_token(user)

        change_password(user)
      end

      it 'allows to change the password' do
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content(t('devise.passwords.updated_not_active'))
      end

      it 'sends email notification on password change' do
        open_email(user.email)

        expect(current_email.subject).to eq t('devise.mailer.password_change.subject')
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
