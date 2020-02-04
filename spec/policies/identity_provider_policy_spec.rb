require 'spec_helper'

RSpec.describe IdentityProviderPolicy, type: :policy do
  subject { described_class.new(user, :identity_provider) }

  let(:existing_user) { create(:user) }

  it_behaves_like 'user is not signed-in policy'

  context 'when user is signed-in to manage connected accounts' do
    permitted_actions = %i[link unlink]

    context 'with user role' do
      let(:user) { existing_user }

      it { is_expected.to permit_actions(permitted_actions) }
    end

    context 'with admin role' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to permit_actions(permitted_actions) }
    end
  end
end
