# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
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
#  provider               :string
#  uid                    :string
#  facebook_picture_url   :string
#  token                  :string
#  token_expiry           :datetime
#  admin                  :boolean          default(FALSE), not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  photo                  :string
#
# Indexes
#
#  index_users_on_coach_id              (coach_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Je prends un user qui a un seul slot à venir, dans la même journée
  # Je vérifie que user.next_slots intègre bien ce slot

  test "next slot is today" do
    travel_to DateTime.new(2017, 9, 5, 11, 0) do
      # verify
      assert_equal 3, User.find_by(email: "georges@abitbol.com").next_slots.count
    end
  end
end
