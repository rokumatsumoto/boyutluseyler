class BackfillUsersEventsCount < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    safety_assured do
      execute <<-SQL.squish
          UPDATE users
            SET events_count = (SELECT count(*)
                                  FROM ahoy_events ae
                                 WHERE  ae.user_id = users.id and ae.name = 'Downloaded design')
      SQL
    end
  end

  def down; end
end
