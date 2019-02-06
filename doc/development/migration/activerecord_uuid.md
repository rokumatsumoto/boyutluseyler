## Active Record UUID

#### In future migrations

You’ll have to use `type: :uuid` when creating relations.

```
class AddNewTable < ActiveRecord::Migration[5.2]
  def change
    create_table :related_model do |t|
      t.references :other, type: :uuid, index: true
    end
  end
end

add_references :item, :user_id, :uuid
```

#### Order and Index

* Default sorting in Rails is on the `id` column, which is no longer relevant when uuid types are used.
* A default scope of `default_scope -> { order("created_at ASC") }` may be necessary for models.
* Also a consideration is adding an index for the `created_at` column:

```
class AddCreatedAtIndexes < ActiveRecord::Migration
  def up
    add_index :categories, :created_at
    add_index :products, :created_at
    add_index :users, :created_at
  end
end
```


#### Refs

https://andycroll.com/ruby/choose-uuids-for-model-ids-in-rails/

https://uysim.com/use-uuid-as-primary-key-in-ruby-on-rails/

https://gist.github.com/wrburgess/c1678788181d5f5577c6e84ac5a3efab
