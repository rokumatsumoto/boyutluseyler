class RemoveBlueprintsImageUrl < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :blueprints, :image_url, :string }
  end
end
