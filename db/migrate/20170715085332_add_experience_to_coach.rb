class AddExperienceToCoach < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :experience, :integer, default: null
  end
end
