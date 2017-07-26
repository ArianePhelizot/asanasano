# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_owner_id  (owner_id)
#

class Group < ApplicationRecord
   has_and_belongs_to_many :users
   has_and_belongs_to_many :coaches
   belongs_to :owner, class_name: "User"
   has_many :courses, dependent: :nullify

   validates :name, presence: true, length: { maximum: 100 }
   validates :owner_id, presence: true

  def group_joined_users_only
    self.users.select do |user|
      !user.invitation_token?
    end
  end

end
