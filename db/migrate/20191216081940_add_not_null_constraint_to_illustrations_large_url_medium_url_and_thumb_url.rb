class AddNotNullConstraintToIllustrationsLargeUrlMediumUrlAndThumbUrl < ActiveRecord::Migration[5.2]
  def change
    change_column_null :illustrations, :large_url, false
    change_column_null :illustrations, :medium_url, false
    change_column_null :illustrations, :thumb_url, false
  end
end
