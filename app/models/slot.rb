# == Schema Information
#
# Table name: slots
#
#  id                :integer          not null, primary key
#  date              :date
#  start_time_hour   :integer
#  start_time_minute :integer
#  end_time_hour     :integer
#  end_time_minute   :integer
#  participants_min  :integer
#  price_cents       :integer          default("0"), not null
#  price_currency    :string           default("EUR"), not null
#  specificities     :string
#  status            :integer          default("0")
#  course_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_slots_on_course_id  (course_id)
#

class Slot < ApplicationRecord

belongs_to :course

enum status: [ :created, :confirmed, :cancelled, :archived ]

validates :date, :start_time_hour , :start_time_minute, :end_time_hour, :end_time_minute , :course_id, :price_cents, presence: true
validates :specificities, length: { maximum: 300 }
validates :start_time_hour, :end_time_hour, inclusion: { in: (1..24).to_a}
validates :start_time_minute, :end_time_minute, inclusion: { in: [0, 15, 30, 45]}

end
