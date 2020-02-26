class AddHourlyDownloadsCountAtToDesigns < ActiveRecord::Migration[5.2]
  def change
    add_column :designs, :hourly_downloads_count_at, :datetime
  end
end
