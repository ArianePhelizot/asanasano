# frozen_string_literal: true

module ApplicationHelper
  # On dashboard page

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

  # rubocop:disable Metrics/AbcSize
  def date_with_mention_if_today_tomorrow(date)
    jour = l(date, format: "%A %e %B %Y")
    if date == Date.today
      "Aujourd'hui, " + jour
    elsif date == Date.today + 1.days
      "Demain, " + jour
    elsif date == Date.today + 2.days
      "Après-demain, " + jour
    else
      jour.capitalize
    end
  end
  # rubocop:enable Metrics/AbcSize
end
