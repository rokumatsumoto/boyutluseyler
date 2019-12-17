class RemoveIllustrationsImageUrl < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :illustrations, :image_url, :string }
  end
end
