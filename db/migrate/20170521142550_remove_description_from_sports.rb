# frozen_string_literal: true

class RemoveDescriptionFromSports < ActiveRecord::Migration[5.0]
  def change
    remove_column :sports, :description, :string
  end
end
