class AddPopularityScoreToDesigns < ActiveRecord::Migration[5.2]
  def up
    add_column :designs, :popularity_score, :float
    change_column_default :designs, :popularity_score, 0.0
  end

  def down
    remove_column :designs, :popularity_score
  end
end
