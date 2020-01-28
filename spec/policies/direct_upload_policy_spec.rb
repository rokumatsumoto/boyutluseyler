require 'spec_helper'

RSpec.describe DirectUploadPolicy, type: :policy do
  subject { described_class.new(user, :direct_upload) }

  let(:existing_user) { create(:user) }

  it_behaves_like 'user is not signed-in policy'

  context 'when user uploads a file using direct upload' do
    context 'with user role' do
      let(:user) { existing_user }

      it { is_expected.to permit_action(:new) }
    end

    context 'with admin role' do
      xit { is_expected.to permit_action(:new) }
    end
  end
end
