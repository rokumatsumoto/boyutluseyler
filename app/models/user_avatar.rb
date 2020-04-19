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

class UserAvatar < ApplicationRecord
  # TODO: Add regex constraints for url fields
  # TODO: move to Boyutluseyler::Regex module

  belongs_to :user

  validates :letter_avatar_url, presence: true
  validates :letter_avatar_thumb_url, presence: true
  validates :user, uniqueness: true
end
