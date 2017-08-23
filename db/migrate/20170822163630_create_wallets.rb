class CreateWallets < ActiveRecord::Migration[5.0]
  def change
    create_table :wallets do |t|
      t.references :account, foreign_key: true, index: true
      t.string :tag
      t.integer :mangopay_id
      t.timestamps
    end
  end
end
