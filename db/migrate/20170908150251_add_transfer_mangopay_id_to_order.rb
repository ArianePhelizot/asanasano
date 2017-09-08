class AddTransferMangopayIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :transfer_mangopay_id, :integer
  end
end
