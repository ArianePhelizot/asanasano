require 'test_helper'

class UpdateSlotStatusJobTest < ActiveJob::TestCase

  test "Good slot update done by my update_slot_status_job" do
    # setup
    travel_to Date.new(2017,9,8) do
    # exercise
    UpdateSlotStatusJob.perform_now
    # verify
    assert_equal 2, Slot.all.where(status: "passed").count
    # teardown
    end
  end
end
