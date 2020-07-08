require 'spec_helper'
RSpec.describe 'Signup' do
  let(:new_user) { build_stubbed(:user) }

  before do
    visit root_path
    click_link 'nav_sign_up'
  end

  it_behaves_like 'validates username' do
    let(:form_submit_button_id) { 'btn_sign_up' }
  end

  context 'with no errors' do
    if defined?(AWS_LAMBDA)
      lambda_functions = {
        'serverless-initials-avatar-dev-initials': {
          payload: '{"statusCode": 200,"body":"{\"message\":\"avatar.png\"}"}'
        }
      }

      AWS_LAMBDA.stub_responses(:invoke, lambda { |context|
        lambda_functions[context.params[:function_name].to_sym]
      })
    end

    context 'when sending confirmation email' do
      it 'creates the user account and sends a confirmation email' do
        fill_in 'user_username',              with: new_user.username
        fill_in 'user_email',                 with: new_user.email
        fill_in 'user_password',              with: new_user.password

        expect { click_button 'btn_sign_up' }.to change(User, :count).by(1)

        expect(page).to have_current_path root_path
        expect(page).to have_content(unconfirmed_message_for_user)
      end
    end
  end

  context 'with errors' do
    let(:existing_user) { create(:user) }

    before do
      fill_in 'user_username', with: new_user.username
      fill_in 'user_email',    with: existing_user.email
      fill_in 'user_password', with: new_user.password
      click_button 'btn_sign_up'
    end

    it 'displays the errors' do
      expect(page).to have_current_path user_registration_path
      expect(page).to have_content(taken_message_for_email)
    end

    it 'does not redisplay the password' do
      expect(page).to have_current_path user_registration_path
      expect(page.body).not_to match(/#{new_user.password}/)
    end
  end

  def unconfirmed_message_for_user
    t('devise.registrations.signed_up_but_unconfirmed')
  end
end
