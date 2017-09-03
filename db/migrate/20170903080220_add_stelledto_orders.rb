class AddStelledtoOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :settled, :boolean, default: false, null: false
  end
end
