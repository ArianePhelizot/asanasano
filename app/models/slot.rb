# == Schema Information
#
# Table name: slots
#
#  id               :integer          not null, primary key
#  date             :date
#  participants_min :integer
#  price_cents      :integer          default("0"), not null
#  price_currency   :string           default("EUR"), not null
#  specificities    :string
#  status           :integer          default("0")
#  course_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  start_at         :datetime
#  end_at           :datetime
#
# Indexes
#
#  index_slots_on_course_id  (course_id)
#

class Slot < ApplicationRecord

  belongs_to :course

  enum status: [ :created, :confirmed, :cancelled, :archived ]

  monetize :price_cents

  validates :date, :start_at, :end_at,  :course_id, :price_cents, presence: true
  validates :specificities, length: { maximum: 300 }
  validates :price, :numericality => true
  validates :participants_min, inclusion: { in: 0..500}

end
