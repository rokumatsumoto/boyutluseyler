class AddExternalFlagToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :external, :boolean
    change_column_default :users, :external, false
  end

  def down
    remove_column :users, :external
  end
end
