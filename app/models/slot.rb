# frozen_string_literal: true

# == Schema Information
#
# Table name: slots
#
#  id                 :integer          not null, primary key
#  date               :date
#  participants_min   :integer
#  price_cents        :integer          default(0), not null
#  price_currency     :string           default("EUR"), not null
#  specificities      :string
#  status             :integer          default("created")
#  course_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_at           :datetime
#  end_at             :datetime
#  payout_mangopay_id :integer
#
# Indexes
#
#  index_slots_on_course_id  (course_id)
#
require "icalendar"

class Slot < ApplicationRecord
  belongs_to :course
  has_and_belongs_to_many :users
  has_many :orders

  enum status: %i(created confirmed cancelled passed archived) # from 0 to 4

  monetize :price_cents

  validates :date, :start_at, :end_at, :course_id, :price_cents, presence: true
  validates :specificities, length: { maximum: 300 }
  validates :price, numericality: { allow_nil: true, greater_than_or_equal_to: 0.1,
                                    less_than_or_equal_to: 2500,
                                    message: "Entrez un prix compris entre 0,10 et 2 500€" }
  validates :participants_min, numericality: { only_integer: true }

  def full?
    users.count == course.capacity_max
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable LineLength
  def mangopay_payout_tag
    "Slot: #{id} du #{date.strftime('%d/%m/%y')} - Course: #{course.id}, #{course.name} - Coach: #{course.coach_id}/User_id: #{course.coach.user.id}, #{course.coach.user.first_name.first}.#{course.coach.user.last_name} - #{users.count} participants "
  end
  # rubocop:enable LineLength

  # rubocop:disable Metrics/MethodLength
  def ical
    # Create a calendar with an event (standard method)
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new(start_at)
      e.dtend       = Icalendar::Values::DateTime.new(end_at)
      e.summary     = "#{course.name.capitalize} avec #{course.coach.user.first_name.capitalize}"
      e.description = " #{specificities} \n #{course.content} \n #{course.details}. "
      e.ip_class    = "PRIVATE"
      e.location = "Rdv: #{course.meeting_point} - #{course.address}"
      e.organizer = course.coach.user.email
    end
    cal
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
