class AddLargeUrlMediumUrlAndThumbUrlToIllustrations < ActiveRecord::Migration[5.2]
  def up
    add_column :illustrations, :large_url, :string
    change_column_default :illustrations, :large_url, ''

    add_column :illustrations, :medium_url, :string
    change_column_default :illustrations, :medium_url, ''

    add_column :illustrations, :thumb_url, :string
    change_column_default :illustrations, :thumb_url, ''
  end

  def down
    remove_column :illustrations, :large_url
    remove_column :illustrations, :medium_url
    remove_column :illustrations, :thumb_url
  end
end
