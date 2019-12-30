class AddNotNullConstraintToUsersAvatarThumbUrlAndAvatarUrl < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :avatar_thumb_url, false
    change_column_null :users, :avatar_url, false
  end
end
