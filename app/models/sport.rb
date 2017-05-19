
# == Schema Information
#
# Table name: sports
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Sport < ApplicationRecord
  has_attachment :photo
  has_attachment :icon
  has_and_belongs_to_many :coaches

  validates :name, :photo, :icon, presence: true
  validates :description, length: { maximum: 500 }

end
