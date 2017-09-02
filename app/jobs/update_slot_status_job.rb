class UpdateSlotStatusJob < ApplicationJob
  queue_as :default

  def perform
      #  je prends tous les slots en base dont la date était hier
      # Slot.all.select {|slot| slot.date < (DateTime.now - 2.days)}
      # si le status est "created" ou "confirmed", je le passe à "passed"
      # rappels status "created confirmed cancelled passed"
      yesterday_slots = Slot.all.select {|slot| (slot.date + 1.days).past?}
      if yesterday_passed_slots = yesterday_slots.select {|slot| slot.status == "created"||"confirmed" }
        yesterday_passed_slots.each do |slot|
          slot.status = "passed"
          slot.save
        end
      end
  end
end
