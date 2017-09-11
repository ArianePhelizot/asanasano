class UpdateSlotStatusJob < ApplicationJob
  queue_as :default

  def perform
    # Selection of all slots with both a due slot date
    # and a "created" or "confirmed status", i.e not "cancelled", nor "archived"
    passed_slots = Slot.all.select { |slot|
      slot.date.past?
    }

    #unable to factorize this code properly using .select and ||!!
    passed_slots_created = passed_slots.select { |slot| slot.status == "created"}
    passed_slots_created.each do |slot|
      slot.status = "passed"
      slot.save
    end


    passed_slots_confirmed = passed_slots.select { |slot| slot.status == "confirmed"}
    passed_slots_confirmed.each do |slot|
      slot.status = "passed"
      slot.save
    end

  end
end
