# frozen_string_literal: true

class CreateJoinTableUserSlot < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :slots do |t|
      t.index %i(user_id slot_id)
    end
  end
end
