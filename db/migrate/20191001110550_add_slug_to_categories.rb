# frozen_string_literal: true

class AddSlugToCategories < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true, algorithm: :concurrently
  end
end
