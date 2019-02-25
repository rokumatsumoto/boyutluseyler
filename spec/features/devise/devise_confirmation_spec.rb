require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Devise confirmation', tag: :devise_default do
  include ConfirmationHelpers
  context 'with no errors' do
    context 'with unconfirmed email' do
      it 'sends confirmation instructions' do
        user = create(:user, :unconfirmed)
        resend(user)

        open_email(user.email)

        expect(current_email.subject).to eq t('devise.mailer.confirmation_instructions.subject')
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
