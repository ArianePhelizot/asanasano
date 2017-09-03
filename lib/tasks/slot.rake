namespace :slot do
  desc "Daily automatic update of slot status in order to flag passed course,
        i.e not cancelled and passed"
  task update_slot_status_to_passed_if_passed: :environment do
    UpdateSlotStatusJob.perform_now
  end
end
