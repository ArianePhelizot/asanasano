class UpdateSlotStatusJob < ApplicationJob
  queue_as :default

  def perform
    # Selection of all slots with both a due slot date
    # and a "created" or "confirmed status", i.e not "cancelled"
    passed_slots = Slot.all.select { |slot|
      slot.date.past?
    }

    passed_and_not_cancelled_slots = passed_slots.select { |slot|
      slot.status == "created" || "confirmed"
    }

    # We the change the status of those slots to "passed"
    passed_and_not_cancelled_slots.each do |slot|
      slot.status = "passed"
      slot.save
    end
  end
end
