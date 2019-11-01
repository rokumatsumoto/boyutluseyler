class ValidateCreateDesignIllustrations < ActiveRecord::Migration[5.2]
  def change
    validate_foreign_key :design_illustrations, :designs
    validate_foreign_key :design_illustrations, :illustrations
  end
end
