# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  users_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_users_id  (users_id)
#

class Group < ApplicationRecord
   validates :name, presence: true, length: { maximum: 20 }
   belongs_to :user, foreign_key: "owner_id"
end

