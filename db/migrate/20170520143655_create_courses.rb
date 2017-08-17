# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :content

      t.string :address
      t.float :lat
      t.float :lng
      t.string :meeting_point

      t.integer :capacity_max
      t.string :details

      t.references :group, foreign_key: true, index: true
      t.references :coach, foreign_key: true, index: true
      t.references :sport, foreign_key: true, index: true

      t.integer :status, default: 0

      t.timestamps
    end
  end
end
