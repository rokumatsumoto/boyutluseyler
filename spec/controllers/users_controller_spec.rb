require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #exists' do
    before do
      sign_in(user)
    end

    context 'when user exists' do
      it 'returns JSON indicating the user exists' do
        get :exists, params: { username: user.username }

        expected_json = { exists: true, message: exists_message_for_username }.to_json
        expect(response.body).to eq(expected_json)
      end

      # rubocop:disable RSpec/NestedGroups
      context 'when the casing is different' do
        let(:user) { create(:user, username: 'CamelCaseUser') }

        it 'returns JSON indicating the user exists' do
          get :exists, params: { username: user.username.downcase }

          expected_json = { exists: true, message: exists_message_for_username }.to_json
          expect(response.body).to eq(expected_json)
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end

    context 'when the user does not exist' do
      it 'returns JSON indicating the user does not exist' do
        get :exists, params: { username: 'foo' }

        expected_json = { exists: false }.to_json
        expect(response.body).to eq(expected_json)
      end
    end
  end

  def exists_message_for_username
    t('activerecord.errors.models.user.attributes.username.taken')
  end
end
# rubocop:enable Metrics/BlockLength
