class AddNotNullConstraintToDesignsDownloadsCount < ActiveRecord::Migration[5.2]
  def change
    change_column_null :designs, :downloads_count, false
  end
end
