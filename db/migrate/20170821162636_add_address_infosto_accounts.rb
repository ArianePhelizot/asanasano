class AddAddressInfostoAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :address_line1, :string
    add_column :accounts, :address_line2, :string
    add_column :accounts, :city, :string
    add_column :accounts, :region, :string
    add_column :accounts, :postal_code, :string
  end
end
