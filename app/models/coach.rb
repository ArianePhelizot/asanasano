# == Schema Information
#
# Table name: coaches
#
#  id          :integer          not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Coach < ApplicationRecord
  delegate :photo, to: :course, prefix: true
    has_and_belongs_to_many :sports
    has_and_belongs_to_many :groups
    has_one :user
    has_many :courses
end
