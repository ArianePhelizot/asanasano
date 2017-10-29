class AddStuff2ToCoaches < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :price, :text
    rename_column :coaches, :where, :locations
    add_column :coaches, :comments, :text
  end
end
