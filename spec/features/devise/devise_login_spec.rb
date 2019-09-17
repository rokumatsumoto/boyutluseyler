require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
# rubocop:disable Metrics/BlockLength
# rubocop:disable RSpec/MultipleExpectations
RSpec.describe 'Devise login', tag: :devise_default do
  describe 'with unconfirmed account' do
    let(:user) { create(:user, :unconfirmed) }

    it 'blocks unconfirmed account login and shows confirmation page link' do
      boyutluseyler_sign_in(user)

      page.within '.alert' do
        expect(page).to have_link(nil, href: new_user_confirmation_path)
      end
    end
  end

  describe 'with locked account' do
    let(:user) { create(:user, :locked) }

    it 'blocks locked account login and shows unlock account page link' do
      boyutluseyler_sign_in(user)

      page.within '.alert' do
        expect(page).to have_link(nil, href: new_user_unlock_path)
      end
    end
  end

  describe 'with invalid username and password' do
    let(:user) { create(:user, password: 'not-the-default') }

    context 'when 2 failed attempts' do
      it 'blocks invalid login and warns about last attempt' do
        2.times do
          boyutluseyler_sign_in(user)
        end

        expect(page).to have_content(t('devise.failure.last_attempt'))
      end
    end

    context 'when 3 failed attempts' do
      before do
        3.times do
          boyutluseyler_sign_in(user)
        end
      end

      it 'blocks invalid login, locks the account and shows unlock account page link' do
        page.within '.alert' do
          expect(page).to have_link(nil, href: new_user_unlock_path)
        end
      end

      it 'sends unlock instructions' do
        open_email(user.email)

        expect(current_email.subject).to eq t('devise.mailer.unlock_instructions.subject')
      end
    end
  end

  describe 'with remember me option' do
    let(:user) { create(:user) }

    context 'when "remember me" is checked' do
      it 'remembers the user after a browser restart' do
        boyutluseyler_sign_in(user, remember: true)

        clear_browser_session

        visit(root_path)

        expect(page).to have_css('a#user-dropdown')
        expect(page).to have_current_path root_path
      end
    end

    context 'when "remember me" is not checked' do
      it 'does not remember the user after a browser restart' do
        boyutluseyler_sign_in(user)

        clear_browser_session

        visit(root_path)

        expect(page).not_to have_css('a#user-dropdown')
        expect(page).to have_current_path root_path
      end
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable Metrics/BlockLength
# rubocop:enable RSpec/DescribeClass
