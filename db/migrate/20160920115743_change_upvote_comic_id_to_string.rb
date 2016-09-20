class ChangeUpvoteComicIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :upvotes, :comic_id, :string, null: false
  end
end
