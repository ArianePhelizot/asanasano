# == Schema Information
#
# Table name: params_sets
#
#  id                          :integer          not null, primary key
#  name                        :string
#  description                 :string
#  fees_on_payout              :float
#  payout_delay_in_days        :integer
#  free_refund_policy_in_hours :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class ParamsSet < ApplicationRecord
  has_many :coaches
  validates :name, :description, :fees_on_payout, :payout_delay_in_days,
            :free_refund_policy_in_hours, presence: true
  validates :fees_on_payout, :payout_delay_in_days,
            :free_refund_policy_in_hours, numericality: true
  validates :fees_on_payout,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end




