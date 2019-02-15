require 'spec_helper'

RSpec.describe NavHelper do
  describe '#header_links' do
    context 'when the user is logged in' do
      let(:user) { build_stubbed(:user) }

      before do
        allow(helper).to receive(:current_user).and_return(user)
      end

      it 'has all the expected links by default' do
        menu_items = %i[user_dropdown upload search designs collections]

        expect(helper.header_links).to contain_exactly(*menu_items)
      end
    end

    it 'returns sign in, search, designs and collections links when the user is
        not logged in' do
      allow(helper).to receive(:current_user).and_return(nil)

      expect(helper.header_links).to contain_exactly(:sign_in, :search, :designs,
                                                     :collections)
    end
  end
end
