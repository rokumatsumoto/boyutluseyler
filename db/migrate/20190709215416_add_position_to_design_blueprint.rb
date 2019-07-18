class AddPositionToDesignBlueprint < ActiveRecord::Migration[5.2]
  def change
    add_column :design_blueprints, :position, :integer
    Design.all.each do |design|
      design.design_blueprints.order(:updated_at).each.with_index(1) do |design_blueprint, index|
        design_blueprint.update_column :position, index
      end
    end
  end
end
