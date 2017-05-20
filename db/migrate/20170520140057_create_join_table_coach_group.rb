class CreateJoinTableCoachGroup < ActiveRecord::Migration[5.0]
  def change
    create_join_table :Coaches, :Groups do |t|
      t.index [:coach_id, :group_id]
    end
  end
end
