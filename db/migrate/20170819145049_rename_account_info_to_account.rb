class RenameAccountInfoToAccount < ActiveRecord::Migration[5.0]
  def change
    rename_table :account_infos, :accounts
  end
end
