require 'spec_helper'

RSpec.describe IdentityProviderPolicy, type: :policy do
  subject { described_class.new(user, 'provider') }

  let(:existing_user) { create(:user) }

  context 'when user is not signed-in' do
    let(:user) { nil }

    it { within_block_is_expected.to raise_error(Pundit::NotAuthorizedError) }
  end

  context 'when user is signed-in to manage connected accounts' do
    permitted_actions = %i[link unlink]

    context 'with user role' do
      let(:user) { existing_user }

      it { is_expected.to permit_actions(permitted_actions) }
    end

    context 'with admin role' do
      xit { is_expected.to permit_actions(permitted_actions) }
    end
  end
end
