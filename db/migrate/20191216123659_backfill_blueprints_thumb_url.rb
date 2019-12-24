class BackfillBlueprintsThumbUrl < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Blueprint.unscoped.in_batches do |relation|
      relation.update_all thumb_url: ''
      sleep(0.1)
    end
  end

  def down; end
end
