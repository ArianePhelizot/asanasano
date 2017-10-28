class AddStuffToCoaches < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :training, :text
    add_column :coaches, :validated, :boolean, default: false, null: false
    add_column :coaches, :public, :boolean, default: false, null: false
    add_column :coaches, :availabilities, :text
    add_column :coaches, :where, :text
  end
end
