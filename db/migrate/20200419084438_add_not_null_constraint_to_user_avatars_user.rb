class AddNotNullConstraintToUserAvatarsUser < ActiveRecord::Migration[5.2]
  def change
    change_column_null :user_avatars, :user_id, false
  end
end
