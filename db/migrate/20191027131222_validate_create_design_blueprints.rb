class ValidateCreateDesignBlueprints < ActiveRecord::Migration[5.2]
  def change
    validate_foreign_key :design_blueprints, :designs
    validate_foreign_key :design_blueprints, :blueprints
  end
end
