require 'spec_helper'

# RSpec.describe 'Signup' do
#   describe 'username validation' do
#     before do
#       visit root_path
#       click_link 'Kaydol'
#     end

#     it 'does not show an error border if the username is available' do
#       fill_in 'user_username', with: 'new-user'
#     end
#   end
# end

RSpec.describe 'Users can sign up', type: :feature do
  # rubocop:disable RSpec/ExampleLength
  it 'when providing valid details' do
    # TODO: context with errors, with no errors
    visit root_path
    click_link 'nav_sign_up'
    fill_in 'user_username', with: 'new-user'
    fill_in 'user_email', with: 'test@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'btn_sign_up'
    msg = 'E-posta adresinize hesap aktifleştirme linkini içeren bir e-posta gönderdik.'
    expect(page).to have_content(msg)
  end
  # rubocop:enable RSpec/ExampleLength
end
