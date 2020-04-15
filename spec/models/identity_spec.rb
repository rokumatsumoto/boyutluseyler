# == Schema Information
#
# Table name: identities
#
#  id             :bigint(8)        not null, primary key
#  uid            :string
#  provider       :string
#  auth_data_dump :text
#  user_id        :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

RSpec.describe Identity, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  it { is_expected.to serialize(:auth_data_dump) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }

    context 'with existing user and provider' do
      let(:user) { create(:omniauth_user) }

      it 'returns false for a duplicate entry' do
        identity = user.identities.build(provider: 'twitter', uid: '1234567890')

        expect(identity.validate).to be_falsey
      end

      it 'returns true when a different provider is used' do
        identity = user.identities.build(provider: 'facebook', uid: '1234567890')

        expect(identity.validate).to be_truthy
      end
    end
  end

  describe '.with_uid' do
    it 'finds the identity for the given provider and uid' do
      create(:omniauth_user, provider: 'test_provider2', uid: 'test_uid')
      omniauth_user1 = create(:omniauth_user, provider: 'test_provider1', uid: 'test_uid')

      identity = described_class.with_uid('test_provider1', 'test_uid').first

      expect(identity).to eq(omniauth_user1.identities.first)
    end
  end
end
