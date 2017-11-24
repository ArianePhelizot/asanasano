class AddInsuranceToCoach < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :insurance, :string
  end
end
