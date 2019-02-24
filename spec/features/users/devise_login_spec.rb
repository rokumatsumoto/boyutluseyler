require 'spec_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'DeviseLogin', tag: :devise_default do
  describe 'with unconfirmed account' do
    let(:user) { create(:user, :unconfirmed) }

    it 'blocks unconfirmed account login' do
      boyutluseyler_sign_in(user)

      expect(page).to have_content(t('devise.failure.unconfirmed'))
    end
  end

  describe 'with locked account' do
    let(:user) { create(:user, :locked) }

    it 'blocks locked account login' do
      boyutluseyler_sign_in(user)

      expect(page).to have_content(t('devise.failure.locked'))
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

      it 'blocks invalid login and locks the account' do
        expect(page).to have_content(t('devise.failure.locked'))
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

        expect(page).to have_css('a.dropdown-user-toggle')
        expect(page).to have_current_path root_path
      end
    end

    context 'when "remember me" is not checked' do
      it 'does not remember the user after a browser restart' do
        boyutluseyler_sign_in(user)

        clear_browser_session

        visit(root_path)

        expect(page).not_to have_css('a.dropdown-user-toggle')
        expect(page).to have_current_path root_path
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
