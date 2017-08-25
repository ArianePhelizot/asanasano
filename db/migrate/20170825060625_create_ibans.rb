class CreateIbans < ActiveRecord::Migration[5.0]
  def change
    create_table :ibans do |t|
      t.references :account, foreign_key: true, index: true
      t.integer :mangopay_id
      t.string :tag
      t.string :iban
      t.integer :active

      t.timestamps
    end
  end
end
