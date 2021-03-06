# frozen_string_literal: true

class CreateSports < ActiveRecord::Migration[5.0]
  def change
    create_table :sports do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
