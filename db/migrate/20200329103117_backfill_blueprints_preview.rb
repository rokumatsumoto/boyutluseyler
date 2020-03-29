class BackfillBlueprintsPreview < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Blueprint.where(content_type: Blueprint::PREVIEW_CONTENT_TYPES).find_in_batches do |blueprints|
      blueprints.each do |blueprint|
        blueprint.update_column(:preview, true)
      end
      sleep(0.1)
    end

    Blueprint.where(preview: nil).find_in_batches do |blueprints|
      blueprints.each do |blueprint|
        blueprint.update_column(:preview, false)
      end
      sleep(0.1)
    end
  end

  def down; end
end
