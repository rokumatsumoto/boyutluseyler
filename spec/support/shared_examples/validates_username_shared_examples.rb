# rubocop:disable Metrics/BlockLength
RSpec.shared_examples 'validates username' do
  context 'when username loses focus', :js do
    it 'does not show an error border if the username is available' do
      fill_in 'user_username', with: 'new-user'
      page.find('body').click # simulate blur event
      wait_for_requests

      expect(find('.user_username')).not_to have_css '.is-invalid'
    end

    it 'does not show an error border if the username contains dots (.)' do
      fill_in 'user_username', with: 'new.user.username'
      page.find('body').click
      wait_for_requests

      expect(find('.user_username')).not_to have_css '.is-invalid'
    end

    it 'shows an error border if the username already exists' do
      existing_user = create(:user)

      fill_in 'user_username', with: existing_user.username
      page.find('body').click
      wait_for_requests

      expect(find('.user_username')).to have_css '.is-invalid'
    end

    fit 'shows an error border if the username contains special characters' do
      fill_in 'user_username', with: 'new$user!username'
      page.find('body').click
      wait_for_requests

      # screenshot_and_open_image
      expect(find('.user_username')).to have_css '.is-invalid'
    end
  end

  context 'when form submission', :js do
    it 'shows an error message on submit if the username contains special characters' do
      fill_in 'user_username', with: 'new$user!username'
      page.find('body').click
      wait_for_requests

      click_button form_submit_button_id

      expect(page).to have_content(invalid_message_for_username)
    end
  end

  def invalid_message_for_username
    t('activerecord.errors.models.user.attributes.username.invalid')
  end
end
# rubocop:enable Metrics/BlockLength
