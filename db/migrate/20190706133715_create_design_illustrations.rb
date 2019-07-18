class CreateDesignIllustrations < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    create_table :design_illustrations do |t|
      t.belongs_to :design, null: false
      t.belongs_to :illustration, null: false

      t.timestamps
    end

    add_foreign_key :design_illustrations, :designs, on_delete: :cascade
    add_foreign_key :design_illustrations, :illustrations, on_delete: :cascade
    add_index :design_illustrations, %i[design_id illustration_id], unique: true, algorithm: :concurrently
  end
end
