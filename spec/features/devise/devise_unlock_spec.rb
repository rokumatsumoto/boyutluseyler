require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Devise unlock', tag: :devise_default do
  include UnlockHelpers
  context 'with no errors' do
    context 'with locked account' do
      it 'sends unlock instructions' do
        user = create(:user, :locked)
        resend(user)

        open_email(user.email)

        expect(current_email.subject).to eq t('devise.mailer.unlock_instructions.subject')
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
