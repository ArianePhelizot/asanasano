# frozen_string_literal: true

class AddExperienceToCoach < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :experience, :integer
  end
end
