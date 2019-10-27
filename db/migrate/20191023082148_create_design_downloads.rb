class CreateDesignDownloads < ActiveRecord::Migration[5.2]
  def change
    create_table :design_downloads do |t|
      t.string :step, limit: 50
      t.string :url
      t.belongs_to :design

      t.timestamps
    end

    add_foreign_key :design_downloads, :designs, on_delete: :cascade
  end
end
