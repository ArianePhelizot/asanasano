class CreateSlots < ActiveRecord::Migration[5.0]
  def change
    create_table :slots do |t|

      t.date :date
      t.time :start_time
      t.time :end_time


      t.integer :participants_min
      t.monetize :price

      t.string :specificities
      t.integer :status, default: 0

      t.references :course, foreign_key: true, index: true

      t.timestamps
    end
  end
end

