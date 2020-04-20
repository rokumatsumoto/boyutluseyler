class AddNotNullConstraintsToUsersRoles < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users_roles, :user_id, false
    change_column_null :users_roles, :role_id, false
  end
end
