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
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :groups
  has_one :user
  has_many :courses, dependent: :nullify
  has_attachment :photo

  delegate :first_name, to: :user
  delegate :photo, to: :course, prefix: true

  def name
    "#{self.user.first_name} #{self.user.last_name} "
  end
end
