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
end
