class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :provider
      t.text :auth_data_dump
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
