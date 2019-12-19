class AddNotNullConstraintToDesignsPopularityScore < ActiveRecord::Migration[5.2]
  def change
    change_column_null :designs, :popularity_score, false
  end
end
