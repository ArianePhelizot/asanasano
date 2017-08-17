# frozen_string_literal: true

class CreateJoinTableCoachSport < ActiveRecord::Migration[5.0]
  def change
    create_join_table :coaches, :sports do |t|
      t.index %i(coach_id sport_id)
    end
  end
end
