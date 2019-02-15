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
      expect(page).to have_content('Lütfen yalnızca alfanumerik karakterlerle')
    end

    it 'does not reload the page if the username already exists' do
      existing_user = create(:user)

      fill_in 'user_username', with: existing_user.username
      fill_in 'user_email',                 with: new_user.email
      fill_in 'user_password',              with: new_user.password
      fill_in 'user_password_confirmation', with: new_user.password
      wait_for_requests

      expect_page_to_not_reload do
        click_button 'btn_sign_up'
      end
    end
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
        expect(page).to have_content('E-posta adresinize hesap aktifleştirme linkini')
      end

      # rubocop:enable RSpec/MultipleExpectations
      # rubocop:enable RSpec/ExampleLength
    end
  end

  context 'with errors' do
    let(:existing_user) { create(:user) }

    it 'displays the errors' do
      fill_in 'user_username', with: new_user.username
      fill_in 'user_email',    with: existing_user.email
      fill_in 'user_password', with: new_user.password
      fill_in 'user_password_confirmation', with: new_user.password
      click_button 'btn_sign_up'

      expect(page).to have_current_path user_registration_path
      expect(page).to have_content('E-Posta hali hazırda kullanılmakta')
    end

    it 'does not redisplay the password' do
      fill_in 'user_username', with: new_user.username
      fill_in 'user_email',    with: existing_user.email
      fill_in 'user_password', with: new_user.password
      fill_in 'user_password_confirmation', with: new_user.password
      click_button 'btn_sign_up'

      expect(page).to have_current_path user_registration_path
      expect(page.body).not_to match(/#{new_user.password}/)
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/DescribeClass
