# frozen_string_literal: true

class AddCoachToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :coach, index: true
  end
end
