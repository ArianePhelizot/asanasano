# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject

  def order_confirmation(order)
    @order = order
    @user = order.user

    mail(
      to:         @user.email,
      subject:    "Votre séance de #{@order.slot.course.name}
                  du #{l(@order.slot.start_at, format: '%A %e %B')}
                  est bien réservée !"
    )
  end

  def slot_reminder(slot, user)
    @slot = slot
    @user = user

    mail(
      to:         @user.email,
      subject:    "Petit rappel pour votre séance de #{@slot.course.name}
                  de demain #{l(@slot.start_at, format: '%A %e %B')}
                  à #{l(@slot.start_at, format: '%Hh%M')}."
    )
  end

  def slot_cancellation_with_refund_confirmation(order)
    @order = order
    @user = order.user

    mail(
      to:         @user.email,
      subject:    "Message de confirmation: annulation de votre séance de
                  #{@order.slot.course.name} du
                  #{l(@order.slot.start_at, format: '%A %e %B')}."
    )
  end

  def slot_cancellation_confirmation(order)
    @order = order
    @user = order.user

    mail(
      to:         @user.email,
      subject:    "Message de confirmation: annulation de votre séance de
                  #{@order.slot.course.name} du
                  #{l(@order.slot.start_at, format: '%A %e %B')}."
    )
  end

  def slot_cancellation_by_orga_information(order)
    @order = order
    @user = order.user

    mail(
      to:         @user.email,
      subject:    "Tristesse...votre séance de
                  #{@order.slot.course.name} du
                  #{l(@order.slot.start_at, format: '%A %e %B')} est annulée."
    )
  end
end
