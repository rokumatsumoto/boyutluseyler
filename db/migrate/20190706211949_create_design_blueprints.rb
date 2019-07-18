class CreateDesignBlueprints < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    create_table :design_blueprints do |t|
      t.belongs_to :design, null: false
      t.belongs_to :blueprint, null: false

      t.timestamps
    end

    add_foreign_key :design_blueprints, :designs, on_delete: :cascade
    add_foreign_key :design_blueprints, :blueprints, on_delete: :cascade
    add_index :design_blueprints, %i[design_id blueprint_id], unique: true, algorithm: :concurrently
  end
end
