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
    has_one :user
end
