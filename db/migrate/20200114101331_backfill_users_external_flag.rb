class BackfillUsersExternalFlag < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    User.unscoped.in_batches do |relation|
      relation.update_all external: false
      sleep(0.1)
    end
  end

  def down; end
end
