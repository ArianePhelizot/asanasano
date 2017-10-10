class CoachReminderJob < ApplicationJob
  queue_as :default

# rubocop:disable all
  def perform
    # je sélectionne tous les coach qui ont un cours proposé le surlendemain
    coaches_to_remind = []
    # je regarde tous les slots prévus à j+1
    in_two_day_slots = Slot.all.where(date: DateTime.now + 2.days)
    # je regarde pour chacun de ces slots les users inscrits
    in_two_day_slots.each do |slot|
      # et pour chaque slot, je regarde les coachs concernés et je leur envoie un email
        CoachMailer.coach_slot_reminder(slot, slot.course.coach.user).deliver_now
      end
  end
end
