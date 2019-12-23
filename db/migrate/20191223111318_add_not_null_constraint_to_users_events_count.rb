class AddNotNullConstraintToUsersEventsCount < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :events_count, false
  end
end


