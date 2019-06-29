# frozen_string_literal: true

# This migration comes from gutentag (originally 3)

superclass = ActiveRecord::VERSION::MAJOR < 5 ?
  ActiveRecord::Migration : ActiveRecord::Migration[4.2]
class NoNullCounters < superclass
  def up
    safety_assured do
      change_column :gutentag_tags, :taggings_count, :bigint,
                    default: 0, null: false
    end
  end

  def down
    change_column :gutentag_tags, :taggings_count, :bigint,
                  default: 0, null: true
  end
end
