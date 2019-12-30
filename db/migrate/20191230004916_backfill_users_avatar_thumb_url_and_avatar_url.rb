class BackfillUsersAvatarThumbUrlAndAvatarUrl < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    User.unscoped.in_batches do |relation|
      relation.update_all avatar_thumb_url: '', avatar_url: ''
      sleep(0.1)
    end
  end

  def down; end
end
