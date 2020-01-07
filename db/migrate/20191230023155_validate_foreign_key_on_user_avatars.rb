class ValidateForeignKeyOnUserAvatars < ActiveRecord::Migration[5.2]
  def change
    validate_foreign_key :user_avatars, :users
  end
end
