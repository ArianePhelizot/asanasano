# frozen_string_literal: true

class AddLanguageToCoach < ActiveRecord::Migration[5.0]
  def change
    add_column :coaches, :languages, :text, array: true, default: []
  end
end
