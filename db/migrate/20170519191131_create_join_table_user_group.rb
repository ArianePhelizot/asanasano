# frozen_string_literal: true

class CreateJoinTableUserGroup < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :groups do |t|
      t.index %i(user_id group_id)
    end
  end
end
