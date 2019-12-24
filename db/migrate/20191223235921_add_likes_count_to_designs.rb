class AddLikesCountToDesigns < ActiveRecord::Migration[5.2]
  def self.up
    add_column :designs, :likes_count, :integer
    change_column_default :designs, :likes_count, 0
  end

  def self.down
    remove_column :designs, :likes_count
  end
end
