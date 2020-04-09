require 'spec_helper'

RSpec.describe BlueprintPolicy, type: :policy do
  subject { described_class.new(user, blueprint) }

  let(:existing_user) { create(:user) }
  let(:blueprint) { build_stubbed(:blueprint) }

  it_behaves_like 'user is not signed-in policy'

  context 'when user uploads a design blueprint file' do
    context 'with user role' do
      let(:user) { existing_user }

      it { is_expected.to permit_action(:create) }
    end
  end
end
