class AddMangopayIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :mangopay_id, :integer
  end
end
