require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Confirmation' do
  include ConfirmationHelpers
  context 'with errors' do
    let(:unregistered_user) { build_stubbed(:user) }
    let(:user) { create(:user) }

    context 'when email not found' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'displays not found message' do
        resend(unregistered_user)

        expect(page).not_to have_current_path new_user_session_path
        expect(page).to have_content(not_found_message_for_email)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when email already confirmed' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'displays already confirmed message' do
        resend(user)

        expect(page).not_to have_current_path new_user_session_path
        expect(page).to have_content(already_confirmed_message_for_email)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe 'token' do
    context 'with valid token' do
      it 'confirms email' do
        user = create(:user, :unconfirmed)

        visit(user_confirmation_path(confirmation_token: user.confirmation_token))

        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content(confirmed_message_for_email)
      end
    end

    context 'with invalid token' do
      before do
        visit(user_confirmation_path(confirmation_token: 'invalid-token'))
      end

      it 'redirects to resend confirmation instructions page' do
        expect(page).to have_current_path new_user_confirmation_path(user_email: '')
        expect(page).to have_content(invalid_message_for_confirmation_token)
      end

      it 'does not fill email field on resend confirmation instructions page' do
        expect(page).to have_field('user_email', with: '')
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
