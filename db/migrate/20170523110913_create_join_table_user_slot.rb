class CreateJoinTableUserSlot < ActiveRecord::Migration[5.0]
  def change
      create_join_table :users, :slots do |t|
      t.index [:user_id, :slot_id]
    end
  end
end
