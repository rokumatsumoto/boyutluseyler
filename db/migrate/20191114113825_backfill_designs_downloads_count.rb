class BackfillDesignsDownloadsCount < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    safety_assured do
      execute <<-SQL.squish
          UPDATE designs
            SET downloads_count = (SELECT count(1)
                                     FROM ahoy_events ae
                                    WHERE  ae.name = 'Downloaded design' and ae.properties @> json_build_object('design_id', designs.id)::jsonb)
      SQL
    end
  end
end
