class AddNotNullConstraintToDesignsHourlyDownloadsCount < ActiveRecord::Migration[5.2]
  def change
    change_column_null :designs, :hourly_downloads_count, false
  end
end
