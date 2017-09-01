namespace :slot do
  desc "Daily automatic update of slot status in order to flag passed course,
        i.e not cancelled and passed"
  task update_slot_status_to_passed_if_passed: :environment do
      # Au préalable, en console je prends tous les slots et si la date est passée et
      # que le statut est "created" ou "confirmed", je le passe à "passed"
      # passed_slots = Slot.all.select {|slot| slot.date < (DateTime.now - 1.days)}
      # passed_slots.each {|slot| slot.status = 3}

      #  je prends tous les slots en base dont la date était hier
                  # Slot.all.select {|slot| slot.date < (DateTime.now - 2.days)}
      # si le status est "created" ou "confirmed", je le passe à "passed"
      yesterday_slots = Slot.all.select {|slot| slot.date < (DateTime.now - 1.days)}
      if yesterday_passed_slots = yesterday_slots.select {|slot| slot.status == 0||1 }
        yesterday_passed_slots.each {|slot| slot.status = 3}
      end
  end
end
