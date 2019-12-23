class BackfillDesignsPopularityScore < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    safety_assured do
      now = Time.current.to_i

      execute <<-SQL.squish
          UPDATE designs
            SET popularity_score = (#{Design::POPULARITY_EFFECT * now}) + ((1 - #{Design::POPULARITY_EFFECT}) * extract(epoch from designs.created_at))
      SQL
    end
  end

  def down; end
end
