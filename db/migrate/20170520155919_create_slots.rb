class CreateSlots < ActiveRecord::Migration[5.0]
  def change
    create_table :slots do |t|

      t.date :date
      t.integer :start_time_hour
      t.integer :start_time_minute
      t.integer :end_time_hour
      t.integer :end_time_minute

      t.integer :participants_min
      t.monetize :price

      t.string :specificities
      t.integer :status, default: 0

      t.references :course, foreign_key: true, index: true

      t.timestamps
    end
  end
end

