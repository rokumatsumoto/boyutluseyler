class BackfillGutentagCacheCounter < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Gutentag::Tag.in_batches.update_all taggings_count: 0
  end

  def down; end
end
