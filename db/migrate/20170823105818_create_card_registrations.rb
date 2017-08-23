class CreateCardRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :card_registrations do |t|
      t.references :account, foreign_key: true, index: true
      t.integer :mangopay_id
      t.string :tag
      t.string :access_key
      t.string :preregistration_data
      t.string :card_registration_url
      t.string :registration_data
      t.timestamps
    end
  end
end
