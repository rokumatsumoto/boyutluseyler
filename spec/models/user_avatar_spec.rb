# == Schema Information
#
# Table name: user_avatars
#
#  id                      :bigint(8)        not null, primary key
#  letter_avatar_url       :string           not null
#  letter_avatar_thumb_url :string           not null
#  user_id                 :bigint(8)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe UserAvatar, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
