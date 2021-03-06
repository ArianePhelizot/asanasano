# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string
#  content       :string
#  address       :string
#  lat           :float
#  lng           :float
#  meeting_point :string
#  capacity_max  :integer
#  details       :string
#  group_id      :integer
#  coach_id      :integer
#  sport_id      :integer
#  status        :integer          default("draft")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_courses_on_coach_id  (coach_id)
#  index_courses_on_group_id  (group_id)
#  index_courses_on_sport_id  (sport_id)
#

class Course < ApplicationRecord
  belongs_to :group
  belongs_to :coach
  belongs_to :sport
  has_many :slots, dependent: :nullify

  enum status: %i(draft active archived)

  validates :name, :address, :capacity_max, :group_id, :sport_id, presence: true
  validates :name, length: { maximum: 20 }
  validates :content, :meeting_point, :details, length: { maximum: 300 }
  validates :capacity_max, numericality: { only_integer: true },
                           inclusion: { in: 1..500,
                                        message: "Vous devez entrez un nombre entre 1 et 500" }

  after_create :send_new_activity_slack_notification

  def next_slot
    active_slots = slots.select { |slot| slot.status == "created" || slot.status == "confirmed" }
    active_slots.sort_by(&:start_at).select { |slot| slot.start_at >= Time.now }.first
  end

  def next_slots
    active_slots = slots.select { |slot| slot.status == "created" || slot.status == "confirmed" }
    active_slots.sort_by(&:start_at).select { |slot| slot.end_at >= Time.now + 1.hour }
  end

  def publishable?
    coach.present? && valid? && slots.any? && draft?
  end

  def depublishable?
    active? && slots.none?
  end

  def send_new_activity_slack_notification
    require "slack-notifier"
    slack_hook = "https://hooks.slack.com/services/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"
    notifier = Slack::Notifier.new slack_hook
    notifier.ping "Wahouh new activity:#{name} created for #{group.name} -
    #{Rails.application.class.parent_name} - #{Rails.env}"
  end
end
