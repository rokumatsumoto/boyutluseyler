require 'spec_helper'

RSpec.describe NavHelper do
  describe '#header_links' do
    context 'when the user is logged in' do
      let(:user) { build_stubbed(:user) }

      before do
        allow(helper).to receive(:current_user).and_return(user)
      end

      it 'has user dropdown menu links by default' do
        expect(helper.header_links).to include(:user_dropdown)
      end
    end
  end
end
