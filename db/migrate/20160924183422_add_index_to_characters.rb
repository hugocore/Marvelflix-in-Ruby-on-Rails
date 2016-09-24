class AddIndexToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_index :characters, :name # cannot be unique because Marvel has duplicated characters, buh :(
  end
end
