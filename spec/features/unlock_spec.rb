require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
# rubocop:disable RSpec/MultipleExpectations
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Unlock' do
  include UnlockHelpers
  context 'with errors' do
    let(:unregistered_user) { build_stubbed(:user) }
    let(:user) { create(:user) }

    context 'when email not found' do
      it 'displays not found message' do
        resend(unregistered_user)

        expect(page).not_to have_current_path new_user_session_path
        expect(page).to have_content(not_found_message_for_email)
      end
    end

    context 'when account is not locked' do
      it 'displays was not locked message' do
        resend(user)

        expect(page).not_to have_current_path new_user_session_path
        expect(page).to have_content(not_locked_message_for_account)
      end
    end
  end

  describe 'token' do
    context 'with valid token' do
      it 'unlocks the account' do
        user = create(:user, :locked)
        token = user.send_unlock_instructions

        visit(user_unlock_path(unlock_token: token))

        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content(unlocked_message_for_account)
      end
    end

    context 'with invalid token' do
      before do
        visit(user_unlock_path(unlock_token: 'invalid-token'))
      end

      it 'redirects to resend unlock instructions page' do
        expect(page).to have_current_path new_user_unlock_path(user_email: '')
        expect(page).to have_content(invalid_message_for_unlock_token)
      end

      it 'does not fill email field on resend unlock instructions page' do
        expect(page).to have_field('user_email', with: '')
      end
    end
  end

  describe 'in' do
    specify '10 minutes' do
      user = create(:user, :locked)

      Timecop.travel(10.minutes.from_now) do
        expect(user).not_to be_access_locked
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable RSpec/DescribeClass
