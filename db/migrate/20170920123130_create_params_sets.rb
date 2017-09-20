class CreateParamsSets < ActiveRecord::Migration[5.0]
  def change
    create_table :params_sets do |t|
      t.string :name
      t.string :description
      t.float :fees_on_payout
      t.integer :payout_delay_in_days
      t.integer :free_refund_policy_in_hours
      t.timestamps
    end
  end
end
