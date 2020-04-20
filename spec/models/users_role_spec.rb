# == Schema Information
#
# Table name: users_roles
#
#  user_id :bigint(8)
#  role_id :bigint(8)
#

require 'spec_helper'

RSpec.describe UsersRole, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:role) }
  end
end
