require 'spec_helper'

RSpec.describe 'Users can sign up', type: :feature do
  # rubocop:disable RSpec/ExampleLength
  it 'when providing valid details' do
    # TODO: context with errors, with no errors
    visit '/'
    click_link 'Kaydol'
    fill_in 'Kullanıcı Adı', with: 'test'
    fill_in 'E-Posta', with: 'test@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'Parola Doğrulama', with: 'password'
    click_button 'Kaydol'
    msg = 'E-posta adresinize hesap aktifleştirme linkini içeren bir e-posta gönderdik.'
    expect(page).to have_content(msg)
  end
  # rubocop:enable RSpec/ExampleLength
end
