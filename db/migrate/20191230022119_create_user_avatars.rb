class CreateUserAvatars < ActiveRecord::Migration[5.2]
  def change
    create_table :user_avatars do |t|
      t.string :letter_avatar_url, null: false
      t.string :letter_avatar_thumb_url, null: false
      t.belongs_to :user

      t.timestamps
    end

    add_foreign_key :user_avatars, :users, on_delete: :cascade, validate: false
  end
end
