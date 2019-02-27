require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'User edit profile' do
  let(:user) { create(:user) }

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
      # rubocop:disable RSpec/ExampleLength
      it 'does not reload the page if the username already exists' do
        existing_user = create(:user)

        fill_in 'user_username', with: existing_user.username
        fill_in 'user_email',    with: user.email

        wait_for_requests

        expect_page_to_not_reload do
          click_button 'btn_edit_profile'
        end
      end
      # rubocop:enable RSpec/ExampleLength
      it 'allows form submission if the username is already used' do
        fill_in 'user_username', with: user.username
        fill_in 'user_email',    with: user.email

        wait_for_requests

        expect_page_to_reload do
          click_button 'btn_edit_profile'
        end
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
