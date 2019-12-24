class BackfillIllustrationsLargeUrlMediumUrlAndThumbUrl < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Illustration.unscoped.in_batches do |relation|
      relation.update_all large_url: '', medium_url: '', thumb_url: ''
      sleep(0.1)
    end
  end

  def down; end
end
