class CreateMangopayLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :mangopay_logs do |t|
      t.string :event
      t.references :user, foreign_key: true, index: true
      t.string :mangopay_answer
      t.string :error_logs
      t.timestamps
    end
  end
end
