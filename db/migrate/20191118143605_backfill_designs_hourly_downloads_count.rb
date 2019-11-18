class BackfillDesignsHourlyDownloadsCount < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    safety_assured do
      execute <<-SQL.squish
          UPDATE designs
            SET hourly_downloads_count = designs.downloads_count / (select EXTRACT                                  (EPOCH FROM now()::timestamp -                                           designs.created_at)/3600)
      SQL
    end
  end
end
