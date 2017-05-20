# == Schema Information
#
# Table name: slots
#
#  id               :integer          not null, primary key
#  date             :date
#  start_time       :time
#  end_time         :time
#  participants_min :integer
#  price_cents      :integer          default("0"), not null
#  price_currency   :string           default("EUR"), not null
#  specificities    :string
#  status           :integer          default("0")
#  course_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_slots_on_course_id  (course_id)
#

class Slot < ApplicationRecord

belongs_to :course

enum status: [ :created, :confirmed, :cancelled, :archived ]

validates :date, :start_time , :end_time , :course_id, :price_cents, presence: true
validates :specificities, length: { maximum: 300 }

end
