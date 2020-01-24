require 'spec_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, existing_user) }

  let(:existing_user) { create(:user) }

  context 'when user is not signed-in' do
    let(:user) { nil }

    it { within_block_is_expected.to raise_error(Pundit::NotAuthorizedError) }
  end

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
