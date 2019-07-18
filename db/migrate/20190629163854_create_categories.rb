class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, limit: 50, null: false
      t.text :description
      t.integer :list_order, limit: 2

      t.timestamps
    end
  end
end
