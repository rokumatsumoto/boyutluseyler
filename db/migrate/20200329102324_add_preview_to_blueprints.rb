class AddPreviewToBlueprints < ActiveRecord::Migration[5.2]
  def up
    add_column :blueprints, :preview, :boolean
    change_column_default :blueprints, :preview, false
  end

  def down
    remove_column :blueprints, :preview
  end
end
