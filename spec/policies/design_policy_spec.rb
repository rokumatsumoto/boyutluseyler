require 'spec_helper'

RSpec.describe DesignPolicy, type: :policy do
  subject { described_class.new(user, design) }

  let(:existing_user) { create(:user) }
  let(:design) { build_stubbed(:design) }

  context 'when user is not signed-in' do
    let(:user) { nil }

    it { is_expected.to permit_actions(%i[show latest popular]) }
    it { is_expected.to forbid_actions(%i[new create edit update destroy download like]) }
  end

  context 'when user is not the creator' do
    let(:user) { existing_user }

    it { is_expected.to permit_actions(%i[show new create download like latest popular]) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }
  end

  context 'when user is the creator' do
    let(:design) { build_stubbed(:design, user: existing_user) }
    let(:user) { existing_user }

    it { is_expected.to permit_actions(%i[show new create edit update destroy download like latest popular]) }
  end

  context 'when user is an admin' do
    let(:user) { create(:user, :admin) }

    it { is_expected.to permit_actions(%i[show new create edit update destroy download like latest popular]) }
  end
end
