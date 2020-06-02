require 'spec_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, existing_user) }

  let(:existing_user) { create(:user) }

  it_behaves_like 'user is not signed-in policy'

  context 'when user is signed-in' do
    permitted_actions = %i[show edit update reset]

    context 'with own user account' do
      let(:user) { existing_user }

      it { is_expected.to permit_actions(permitted_actions) }
    end

    context 'with the user role to take action on a different user account' do
      let(:user) { create(:user) }

      it { is_expected.to forbid_actions(%i[show edit update reset]) }
    end

    context 'with admin role' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to permit_actions(permitted_actions) }
    end
  end
end
