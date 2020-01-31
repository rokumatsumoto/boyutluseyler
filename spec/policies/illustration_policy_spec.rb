require 'spec_helper'

RSpec.describe IllustrationPolicy, type: :policy do
  subject { described_class.new(user, illustration) }

  let(:existing_user) { create(:user) }
  let(:illustration) { build_stubbed(:illustration) }

  it_behaves_like 'user is not signed-in policy'

  context 'when user uploads a design illustration file' do
    context 'with user role' do
      let(:user) { existing_user }

      it { is_expected.to permit_action(:create) }
    end

    context 'with admin role' do
      xit { is_expected.to permit_action(:create) }
    end
  end
end
