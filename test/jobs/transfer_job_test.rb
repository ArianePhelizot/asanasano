# require "test_helper"

# class TransferJobTest < ActiveJob::TestCase
#   test "Good working of my TransferJob" do
#     # setup
#     travel_to Date.new(2017, 9, 8) do
#       # exercise
#       UpdateSlotStatusJob.perform_now
#       TransferJob.perform_now
#       # verify
#       assert_equal 2, MangopayLog.all.where(event: "transfer_creation").count
#       # teardown
#     end
#     after_teardown
#   end
# end
