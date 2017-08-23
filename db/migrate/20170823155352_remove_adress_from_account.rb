class RemoveAdressFromAccount < ActiveRecord::Migration[5.0]
  def change
    remove_column :accounts, :address, :string
  end
end
