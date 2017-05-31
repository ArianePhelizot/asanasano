# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  coach_id               :integer
#  phone_number           :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  provider               :string
#  uid                    :string
#  facebook_picture_url   :string
#  token                  :string
#  token_expiry           :datetime
#
# Indexes
#
#  index_users_on_coach_id              (coach_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_and_belongs_to_many :groups
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :nullify
  belongs_to :coach, optional: true
  has_and_belongs_to_many :slots

  has_attachment :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def next_slots
    sorted_slots = self.slots.sort_by(&:date)
    sorted_slots.select { |slot| slot.date >= Time.now}
  end
end
