class BackfillDesignsLikesCount < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    safety_assured do
      execute <<-SQL.squish
          UPDATE designs
            SET likes_count = (SELECT count(1)
                                     FROM ahoy_events ae
                                    WHERE  ae.name = 'Liked design' and ae.properties @> json_build_object('design_id', designs.id)::jsonb)
      SQL
    end
  end

  def down; end
end
