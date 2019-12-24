class AddEventsCountToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :events_count, :integer
    change_column_default :users, :events_count, 0
  end

  def down
    remove_column :users, :events_count
  end
end
