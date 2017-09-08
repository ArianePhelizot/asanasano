class AddRefundMangopayIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :refund_mangopay_id, :integer
  end
end
