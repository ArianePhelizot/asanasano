class AddParamsSetIdCoaches < ActiveRecord::Migration[5.0]
  def change
    add_reference :coaches, :params_set, index: true, foreign_key: true
  end
end
