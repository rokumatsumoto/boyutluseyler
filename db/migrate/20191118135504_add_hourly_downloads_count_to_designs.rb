class AddHourlyDownloadsCountToDesigns < ActiveRecord::Migration[5.2]
  def self.up
    add_column :designs, :hourly_downloads_count, :float
    change_column_default :designs, :hourly_downloads_count, 0.0
  end

  def self.down
    remove_column :designs, :hourly_downloads_count
  end
end
