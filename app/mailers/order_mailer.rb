class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject
  #
  def order_confirmation (current_user, order)
    @user = current_user
    @order = order

    mail(
    to:         @user.email,
    subject:    "Votre séance de #{@order.slot.course.name} du #{@order.slot.date} est bien réservée !"
    )

  end
end
