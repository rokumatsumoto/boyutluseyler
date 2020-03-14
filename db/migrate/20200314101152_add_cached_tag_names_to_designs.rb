class AddCachedTagNamesToDesigns < ActiveRecord::Migration[5.2]
  def change
    add_column :designs, :cached_tag_names, :string
  end
end
