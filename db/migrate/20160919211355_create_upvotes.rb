class CreateUpvotes < ActiveRecord::Migration[5.0]
  def change
    create_table :upvotes do |t|
      t.integer :user_id, null: false
      t.integer :comic_id, null: false
      t.timestamps
    end
  end
end
