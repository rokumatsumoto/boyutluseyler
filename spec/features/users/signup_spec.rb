require 'spec_helper'
# rubocop:disable RSpec/DescribeClass
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Signup' do
  let(:new_user) { build_stubbed(:user) }

  before do
    visit root_path
    click_link 'nav_sign_up'
  end

  describe 'username validation', :js do
    it 'does not show an error border if the username is available' do
      fill_in 'user_username', with: 'new-user'
      wait_for_requests
      page.find('body').click # simulate blur event

      expect(find('.user_username')).not_to have_css '.is-invalid'
    end

    it 'does not show an error border if the username contains dots (.)' do
      fill_in 'user_username', with: 'new.user.username'
      wait_for_requests
      page.find('body').click

      expect(find('.user_username')).not_to have_css '.is-invalid'
    end

    it 'shows an error border if the username already exists' do
      existing_user = create(:user)

      fill_in 'user_username', with: existing_user.username
      wait_for_requests
      page.find('body').click

      expect(find('.user_username')).to have_css '.is-invalid'
    end

    it 'shows an error border if the username contains special characters' do
      fill_in 'user_username', with: 'new$user!username'
      wait_for_requests
      page.find('body').click

      expect(find('.user_username')).to have_css '.is-invalid'
    end

    it 'shows an error message on submit if the username contains special characters' do
      fill_in 'user_username', with: 'new$user!username'
      wait_for_requests

      click_button 'btn_sign_up'
      expect(page).to have_content(invalid_message_for_username)
    end
    # rubocop:disable RSpec/ExampleLength
    it 'does not reload the page if the username already exists' do
      existing_user = create(:user)

      fill_in 'user_username',              with: existing_user.username
      fill_in 'user_email',                 with: new_user.email
      fill_in 'user_password',              with: new_user.password
      fill_in 'user_password_confirmation', with: new_user.password

      expect_page_to_not_reload do
        click_button 'btn_sign_up'
      end
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'with no errors' do
    context 'when sending confirmation email' do
      # rubocop:disable RSpec/ExampleLength
      # rubocop:disable RSpec/MultipleExpectations
      it 'creates the user account and sends a confirmation email' do
        fill_in 'user_username',              with: new_user.username
        fill_in 'user_email',                 with: new_user.email
        fill_in 'user_password',              with: new_user.password
        fill_in 'user_password_confirmation', with: new_user.password

        expect { click_button 'btn_sign_up' }.to change(User, :count).by(1)

        expect(page).to have_current_path root_path
        expect(page).to have_content(unconfirmed_message_for_user)
      end

      # rubocop:enable RSpec/MultipleExpectations
      # rubocop:enable RSpec/ExampleLength
    end
  end

  context 'with errors' do
    let(:existing_user) { create(:user) }

    before do
      fill_in 'user_username', with: new_user.username
      fill_in 'user_email',    with: existing_user.email
      fill_in 'user_password', with: new_user.password
      fill_in 'user_password_confirmation', with: new_user.password
      click_button 'btn_sign_up'
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'displays the errors' do
      expect(page).to have_current_path user_registration_path
      expect(page).to have_content(taken_message_for_email)
    end

    it 'does not redisplay the password' do
      expect(page).to have_current_path user_registration_path
      expect(page.body).not_to match(/#{new_user.password}/)
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  def invalid_message_for_username
    I18n.t('activerecord.errors.models.user.attributes.username.invalid')
  end

  def unconfirmed_message_for_user
    I18n.t('devise.registrations.signed_up_but_unconfirmed')
  end

  def taken_message_for_email
    I18n.t('activerecord.errors.models.user.attributes.email.taken')
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/DescribeClass
