require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'User edit profile' do
  let(:user) { create(:user) }
  let(:existing_user) { create(:user) }

  before do
    sign_in(user)
    visit(edit_user_registration_path)
  end

  it_behaves_like 'validates username' do
    let(:form_submit_button_id) { 'btn_edit_profile' }
  end

  describe 'username validation', :js do
    context 'when username loses focus' do
      it 'does not validation if the username is already used' do
        fill_in 'user_username', with: user.username
        page.find('body').click
        wait_for_requests

        expect(find('.user_username')).not_to have_css '.is-invalid'
      end
    end

    context 'when form submission' do
      it 'allows form submission if the username is already used' do
        fill_in 'user_username', with: user.username
        page.find('body').click

        wait_for_requests

        expect_page_to_reload do
          click_button 'btn_edit_profile'
        end
      end
    end
  end

  context 'with errors' do
    context 'when email already exists' do
      it 'shows email has already been taken message' do
        fill_in 'user_email', with: existing_user.email

        click_button 'btn_edit_profile'

        expect(page).to have_content(t('simple_form.error_notification.default_message'))
        expect(page).to have_content(taken_message_for_email)
      end
    end

    context 'when change password without current password', :js do
      before do
        fill_in 'user_password',              with: user.password
        fill_in 'user_password_confirmation', with: user.password
      end

      it 'shows current password is required message' do
        click_button 'btn_edit_profile'

        expect(page).not_to have_content(t('simple_form.error_notification.default_message'))
        expect(page).to have_content(blank_message_for_current_password)
      end

      it 'does not reload the page' do
        expect_page_to_not_reload do
          click_button 'btn_edit_profile'
        end
      end
    end

    context 'with invalid current password' do
      it 'shows current password is invalid message' do
        fill_in 'user_password',              with: user.password
        fill_in 'user_password_confirmation', with: user.password
        fill_in 'user_current_password',      with: 'invalid-password'

        click_button 'btn_edit_profile'

        expect(page).to have_content(t('simple_form.error_notification.default_message'))
        expect(page).to have_content(invalid_message_for_current_password)
      end
    end
  end

  context 'with no errors' do
    context 'without updating email and password' do
      it 'updates profile' do
        click_button 'btn_edit_profile'

        expect(page).to have_content(t('devise.registrations.updated'))
        expect(page).to have_current_path(edit_user_registration_path(user))
      end
    end

    context 'when email is updated' do
      let(:user_new_email) { 'user_new_email@example.org' }

      before do
        fill_in 'user_email', with: user_new_email

        click_button 'btn_edit_profile'
      end

      it 'sends email changed notification to old email' do
        open_email(user.email)

        expect(current_email.subject).to eq t('devise.mailer.email_changed.subject')
        expect(current_email.to.first).to eq user.email
        expect(page).to have_content(t('devise.registrations.update_needs_confirmation'))
      end

      it 'sends confirmation instructions to new email' do
        open_email(user_new_email)

        expect(current_email.to.first).to eq user_new_email
        expect(current_email.subject).to eq t('devise.mailer.confirmation_instructions.subject')
      end
    end

    context 'when password is updated with valid current password' do
      it 'sends password changed notification' do
        fill_in 'user_password',              with: user.password
        fill_in 'user_password_confirmation', with: user.password
        fill_in 'user_current_password',      with: user.password

        click_button 'btn_edit_profile'

        open_email(user.email)

        expect(current_email.subject).to eq t('devise.mailer.password_change.subject')
        expect(page).to have_content(t('devise.registrations.updated'))
      end
    end
  end

  # rubocop:disable RSpec/PredicateMatcher
  describe 'when I cancel my account', :js do
    it 'deletes user' do
      accept_alert do
        click_button 'btn_cancel_my_account'
      end

      expect(page).to have_current_path root_path
      expect(page).to have_content(t('devise.registrations.destroyed'))
      expect(User.exists?(user.id)).to be_falsy
    end
  end
  # rubocop:enable RSpec/PredicateMatcher

  def blank_message_for_current_password
    t('activerecord.errors.models.user.attributes.current_password.blank')
  end

  def invalid_message_for_current_password
    t('activerecord.errors.models.user.attributes.current_password.invalid')
  end
end
# rubocop:enable RSpec/DescribeClass
