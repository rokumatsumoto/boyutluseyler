class AddNotNullConstraintToBlueprintsThumbUrl < ActiveRecord::Migration[5.2]
  def change
    change_column_null :blueprints, :thumb_url, false
  end
end
