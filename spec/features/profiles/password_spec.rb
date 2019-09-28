require 'spec_helper'

RSpec.describe 'Profile > Password' do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    visit(edit_profile_password_path)
  end

  context 'with errors' do
    context 'when change password without current password', :js do
      before do
        fill_in 'user_password',              with: user.password
        fill_in 'user_password_confirmation', with: user.password
      end

      it 'shows this field is required message for current password' do
        click_button 'btn_save_password'

        expect(page).not_to have_content(invalid_message_for_current_password)
        expect(page).to have_content(t('errors.messages.blank'))
      end

      it 'does not reload the page' do
        expect_page_to_not_reload do
          click_button 'btn_save_password'
        end
      end
    end

    context 'with invalid current password' do
      it 'shows current password is invalid message' do
        fill_in 'user_password',              with: user.password
        fill_in 'user_password_confirmation', with: user.password
        fill_in 'user_current_password',      with: 'invalid-password'

        click_button 'btn_save_password'

        expect(page).to have_content(invalid_message_for_current_password)
      end
    end
  end

  context 'with no errors' do
    context 'when password is updated with valid current password' do
      before do
        fill_in 'user_password',              with: user.password
        fill_in 'user_password_confirmation', with: user.password
        fill_in 'user_current_password',      with: user.password

        click_button 'btn_save_password'
      end

      it 'sends password changed notification' do
        open_email(user.email)

        expect(current_email.subject).to eq t('devise.mailer.password_change.subject')
      end

      it 'redirects to the sign in page' do
        expect(page).to have_content(t('devise.registrations.password_updated_but_not_signed_in'))
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  def invalid_message_for_current_password
    t('activerecord.errors.models.user.attributes.current_password.invalid')
  end
end
