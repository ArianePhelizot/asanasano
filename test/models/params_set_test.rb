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

require "test_helper"

class ParamsSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
