class AddHomePopularAtToDesigns < ActiveRecord::Migration[5.2]
  def change
    add_column :designs, :home_popular_at, :datetime
  end
end
