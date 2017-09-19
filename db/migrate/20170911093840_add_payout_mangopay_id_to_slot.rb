class AddPayoutMangopayIdToSlot < ActiveRecord::Migration[5.0]
  def change
    add_column :slots, :payout_mangopay_id, :integer
  end
end
