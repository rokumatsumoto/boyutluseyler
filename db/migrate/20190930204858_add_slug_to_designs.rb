# frozen_string_literal: true

class AddSlugToDesigns < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :designs, :slug, :string
    add_index :designs, :slug, unique: true, algorithm: :concurrently
  end
end
