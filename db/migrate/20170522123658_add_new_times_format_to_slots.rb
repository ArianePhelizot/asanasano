# frozen_string_literal: true

class AddNewTimesFormatToSlots < ActiveRecord::Migration[5.0]
  def change
    add_column :slots, :start_at, :datetime
    add_column :slots, :end_at, :datetime
    remove_column :slots, :start_time_hour
    remove_column :slots, :start_time_minute
    remove_column :slots, :end_time_hour
    remove_column :slots, :end_time_minute
  end
end
