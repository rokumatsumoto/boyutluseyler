class CreateDesigns < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    create_table :designs do |t|
      t.string :name, limit: 120, null: false
      t.text :description, null: false
      t.text :printing_settings
      t.string :model_file_format
      t.string :license_type, null: false
      t.boolean :allow_comments, default: true, null: false

      t.timestamps
    end

    add_reference :designs, :user, index: false, foreign_key: { on_delete: :cascade }
    add_index :designs, :user_id, algorithm: :concurrently

    add_reference :designs, :category, index: false, foreign_key: { on_delete: :cascade }
    add_index :designs, :category_id, algorithm: :concurrently
  end
end
