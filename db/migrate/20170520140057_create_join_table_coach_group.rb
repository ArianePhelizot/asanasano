# frozen_string_literal: true

class CreateJoinTableCoachGroup < ActiveRecord::Migration[5.0]
  def change
    create_join_table :coaches, :groups do |t|
      t.index %i(coach_id group_id)
    end
  end
end
