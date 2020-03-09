require 'spec_helper'

RSpec.describe NavHelper do
  describe '#header_links' do
    let(:menu_items) { %i[search upload explore category groups] }

    context 'when the user is logged in' do
      let(:user) { build_stubbed(:user) }

      before do
        allow(helper).to receive(:current_user).and_return(user)
      end

      it 'has all the expected links by default' do
        user_menu_items = menu_items + %i[user_dropdown library]

        expect(helper.header_links).to contain_exactly(*user_menu_items)
      end
    end

    it 'returns sign in, search, upload, explore, category and groups links when the user is
        not logged in' do
      anonymous_user_menu_items = menu_items + [:sign_in]
      allow(helper).to receive(:current_user).and_return(nil)

      expect(helper.header_links).to contain_exactly(*anonymous_user_menu_items)
    end
  end
end
