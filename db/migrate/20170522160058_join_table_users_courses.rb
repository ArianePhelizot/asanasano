class JoinTableUsersCourses < ActiveRecord::Migration[5.0]
  def change
    def change
    create_join_table :slots, :users do |t|
      t.index [:slot, :user_id]
    end
  end
  end
end
