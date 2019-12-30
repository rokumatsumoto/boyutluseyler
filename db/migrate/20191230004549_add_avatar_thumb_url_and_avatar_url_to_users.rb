class AddAvatarThumbUrlAndAvatarUrlToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :avatar_thumb_url, :string
    change_column_default :users, :avatar_thumb_url, ''

    add_column :users, :avatar_url, :string
    change_column_default :users, :avatar_url, ''
  end

  def down
    remove_column :users, :avatar_thumb_url
    remove_column :users, :avatar_url
  end
end
