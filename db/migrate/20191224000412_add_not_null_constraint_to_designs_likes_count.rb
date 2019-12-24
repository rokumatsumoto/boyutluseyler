class AddNotNullConstraintToDesignsLikesCount < ActiveRecord::Migration[5.2]
  def change
    change_column_null :designs, :likes_count, false
  end
end
