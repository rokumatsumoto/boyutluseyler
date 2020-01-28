require 'spec_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, existing_user) }

  let(:existing_user) { create(:user) }

  it_behaves_like 'user is not signed-in policy'

  context 'when user is signed-in' do
    permitted_actions = %i[show edit update reset]

    context 'with user role' do
      let(:user) { existing_user }

      it { is_expected.to permit_actions(permitted_actions) }
    end

    context 'with admin role' do
      xit { is_expected.to permit_actions(permitted_actions) }
    end
  end
end
