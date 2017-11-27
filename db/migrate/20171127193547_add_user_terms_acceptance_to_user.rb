class AddUserTermsAcceptanceToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_terms_acceptance, :boolean, default: false, null: false
  end
end
