class AddPositionToDesignIllustration < ActiveRecord::Migration[5.2]
  def change
    add_column :design_illustrations, :position, :integer
    Design.all.each do |design|
      design.design_illustrations.order(:updated_at).each.with_index(1) do |design_illustration, index|
        design_illustration.update_column :position, index
      end
    end
  end
end
