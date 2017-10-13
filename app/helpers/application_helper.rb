# frozen_string_literal: true

module ApplicationHelper
  def slots_dates(slots_array)
    slots_dates = slots_array.map(&:date)
    slots_dates.uniq
  end

  def select_by_date(slots_array, date)
    slots_selected_by_date = slots_array.select { |slot|
      slot.date == date
    }
    slots_selected_by_date
  end
end
