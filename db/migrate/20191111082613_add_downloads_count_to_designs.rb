class AddDownloadsCountToDesigns < ActiveRecord::Migration[5.2]
  def self.up
    add_column :designs, :downloads_count, :integer, null: false, default: 0

    reversible do |dir|
      dir.up { data } # Run on rake db:migrate
      dir.down { } # Run on rake db:rollback.
    end
  end

  def self.down
    remove_column :designs, :downloads_count
  end

  def data
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
