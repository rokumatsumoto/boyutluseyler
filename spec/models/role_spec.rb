# == Schema Information
#
# Table name: roles
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  resource_type :string
#  resource_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

RSpec.describe Role, type: :model do
  describe 'constants' do
    subject { described_class }

    let(:roles) { %w[admin] }

    it { is_expected.to have_constant(:ROLES, Array).with_value(roles) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:users_roles).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:users_roles) }
    it { is_expected.to belong_to(:resource).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
    it { is_expected.to validate_inclusion_of(:name).in_array(described_class::ROLES) }
  end

  describe 'cancel destroying the role' do
    it 'ensures that removing all user from role does not remove role' do
      allow(Rolify).to receive(:remove_role_if_empty).and_return(true)
      role = create(:role)
      user = build_stubbed(:user)
      user.add_role(role.name)

      expect { user.remove_role(role.name) }.not_to change(described_class, :count)
    end
  end
end
