class AddNotNullConstraintsToDesignDownloads < ActiveRecord::Migration[5.2]
  def change
    change_column_null :design_downloads, :design_id, false
    change_column_null :design_downloads, :step, false
  end
end
