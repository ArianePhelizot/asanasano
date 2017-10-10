class MailReminderJob < ApplicationJob
  queue_as :default

# rubocop:disable all
  def perform

    # je sélectionne tous les users qui ont un cours booké le lendemain
    users_to_remind = []


      # je regarde tous les slots prévus à j+1
      next_day_slots = Slot.all.where(date: DateTime.now + 1.days)
      # je regarde pour chacun de ces slots les users inscrits
      next_day_slots.each do |slot|
        # et pour chaque slot, je regarde les users inscrits
        slot.users.each do |user|
          # et je leur envoie un email
          OrderMailer.slot_reminder(slot, user).deliver_now
        end
      end
  end

end
