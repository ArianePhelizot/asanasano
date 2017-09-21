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
                  du #{@order.slot.date}
                  est bien réservée !"
    )
  end

  def slot_cancellation_with_refund_confirmation(order)
    @order = order
    @user = order.user

    mail(
      to:         @user.email,
      subject:    "Message de confirmation: annulation de votre séance de
                  #{@order.slot.course.name} du #{@order.slot.date}."
    )
  end

  def slot_cancellation_confirmation(order)
    @order = order
    @user = order.user

    mail(
      to:         @user.email,
      subject:    "Message de confirmation: annulation de votre séance de
                  #{@order.slot.course.name} du #{@order.slot.date}."
    )
  end

  def slot_cancellation_by_orga_information(order)
    @order = order
    @user = order.user

    mail(
      to:         @user.email,
      subject:    "Tristess...votre séance de
                  #{@order.slot.course.name} du #{@order.slot.date} est annulée."
    )
  end
end
