# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject
  #
  def order_confirmation(current_user, order)
    @user = current_user
    @order = order

    mail(
      to:         @user.email,
      subject:    "Votre séance de #{@order.slot.course.name}
                  du #{@order.slot.date}
                  est bien réservée !"
    )
  end

  def slot_cancellation_with_refund_confirmation(current_user, order)
    @user = current_user
    @order = order

    mail(
      to:         @user.email,
      subject:    "Message de confirmation: annulation de votre séance de
                  #{@order.slot.course.name} du #{@order.slot.date}."
    )
  end

  def slot_cancellation_confirmation(current_user, order)
    @user = current_user
    @order = order

    mail(
      to:         @user.email,
      subject:    "Message de confirmation: annulation de votre séance de
                  #{@order.slot.course.name} du #{@order.slot.date}."
    )
  end
end
