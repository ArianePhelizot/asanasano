class AddIconToSport < ActiveRecord::Migration[5.0]
  def change
    add_column :sports, :icon, :string
  end
end
