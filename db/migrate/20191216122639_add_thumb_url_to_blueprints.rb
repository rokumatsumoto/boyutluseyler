class AddThumbUrlToBlueprints < ActiveRecord::Migration[5.2]
  def up
    add_column :blueprints, :thumb_url, :string
    change_column_default :blueprints, :thumb_url, ''
  end

  def down
    remove_column :blueprints, :thumb_url
  end
end
