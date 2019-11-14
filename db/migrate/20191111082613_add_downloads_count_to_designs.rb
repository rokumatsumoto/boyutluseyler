class AddDownloadsCountToDesigns < ActiveRecord::Migration[5.2]
  def self.up
    add_column :designs, :downloads_count, :integer
    change_column_default :designs, :downloads_count, 0
  end

  def self.down
    remove_column :designs, :downloads_count
  end
end
