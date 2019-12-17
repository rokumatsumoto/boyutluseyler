class MigrateFromImageUrlToThumbUrlOnBlueprints < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Blueprint.unscoped.find_in_batches do |blueprints|
      Blueprint.unscoped.where(id: blueprints.pluck(:id))
                  .update_all('thumb_url=image_url')
    end
  end

  def down
    Blueprint.unscoped.find_in_batches do |blueprints|
      Blueprint.unscoped.where(id: blueprints.pluck(:id))
                  .update_all('image_url=thumb_url')
    end
  end
end
