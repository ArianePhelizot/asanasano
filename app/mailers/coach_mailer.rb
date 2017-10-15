# frozen_string_literal: true

class CoachMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject

  def coach_slot_reminder(slot, user)
    @slot = slot
    @user = user

    attachments["asanasano.ics"] = { mime_type: "application/ics",
                                     content: @slot.ical.to_ical }

    mail(
      to:         @user.email,
      subject:    "Petit rappel pour votre séance de #{@slot.course.name}
                  de après-demain, #{l(@slot.start_at, format: '%A %e %B')},
                  à #{l(@slot.start_at, format: '%Hh%M')}."
    )
  end
end
