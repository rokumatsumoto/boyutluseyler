class BackfillDesignsCachedTagNames < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    safety_assured do
      execute <<-SQL.squish
          UPDATE designs
            SET cached_tag_names = (SELECT string_agg(gutentag_tags.name, ', ')
                                          FROM gutentag_tags INNER JOIN gutentag_taggings
                                          ON gutentag_tags.id = gutentag_taggings.tag_id
                                         WHERE gutentag_taggings.taggable_id = designs.id
                                          AND gutentag_taggings.taggable_type = 'Design')

      SQL
    end
  end

  def down; end
end
