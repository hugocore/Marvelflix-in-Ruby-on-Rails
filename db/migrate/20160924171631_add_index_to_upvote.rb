class AddIndexToUpvote < ActiveRecord::Migration[5.0]
  def change
    add_index :upvotes, [:user_id, :comic_id], unique: true
  end
end
