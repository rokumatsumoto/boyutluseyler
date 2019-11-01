class ValidateCreateSailProfiles < ActiveRecord::Migration[5.2]
  def change
    validate_foreign_key :sail_entries, column: :setting_id
    validate_foreign_key :sail_entries, column: :profile_id
  end
end
