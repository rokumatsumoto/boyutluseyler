class CreateIllustrations < ActiveRecord::Migration[5.2]
  def change
    create_table :illustrations do |t|
      t.string :url, null: false
      t.string :url_path, null: false
      t.integer :size, null: false
      t.string :content_type, null: false
      t.string :image_url

      t.timestamps
    end
  end
end
