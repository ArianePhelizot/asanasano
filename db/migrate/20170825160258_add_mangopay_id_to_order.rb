class AddMangopayIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :mangopay_id, :integer
  end
end
