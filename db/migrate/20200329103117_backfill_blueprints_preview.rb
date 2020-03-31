class BackfillBlueprintsPreview < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Blueprint.where(content_type: Blueprint::PREVIEW_CONTENT_TYPES).find_each do |blueprint|
      blueprint.update_column(:preview, true)
    end

    Blueprint.where(preview: nil).find_each do |blueprint|
      blueprint.update_column(:preview, false)
    end
  end

  def down; end
end
