class MigrateFromImageUrlToThumbUrlOnIllustrations < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Illustration.unscoped.find_in_batches do |illustrations|
      Illustration.unscoped.where(id: illustrations.pluck(:id))
                  .update_all('thumb_url=image_url')
    end
  end

  def down
    Illustration.unscoped.find_in_batches do |illustrations|
      Illustration.unscoped.where(id: illustrations.pluck(:id))
                  .update_all('image_url=thumb_url')
    end
  end
end
