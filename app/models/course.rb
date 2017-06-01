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
#  status        :integer          default("0")
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

  enum status: [ :draft, :active, :archived ]

  validates :name, :address, :capacity_max, :group_id, :sport_id, presence: true
  validates :content, :meeting_point, :details, length: { maximum: 300 }
  validates :content, :meeting_point, :details, length: { maximum: 300 }
  validates :capacity_max, numericality: { only_integer: true }, inclusion: { in: 1..500,
                           message: "Vous devez entrez un nombre entre 1 et 500" }

  def next_slot
    slots.sort_by(&:date).select { |slot| slot.date >= Time.now }.first
  end

  def next_slots
    slots.sort_by(&:date).select { |slot| slot.date >= Time.now }
  end

  def publishable?
    valid? && slots.any? && draft?
  end

  def depublishable?
    active? && !slots.any?
  end
end
