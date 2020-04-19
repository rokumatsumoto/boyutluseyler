# == Schema Information
#
# Table name: user_avatars
#
#  id                      :bigint(8)        not null, primary key
#  letter_avatar_url       :string           not null
#  letter_avatar_thumb_url :string           not null
#  user_id                 :bigint(8)        not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'spec_helper'

RSpec.describe UserAvatar, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:user_avatar) }

    it { is_expected.to validate_presence_of(:letter_avatar_url) }
    it { is_expected.to validate_presence_of(:letter_avatar_thumb_url) }
    it { is_expected.to validate_uniqueness_of(:user) }
  end
end
