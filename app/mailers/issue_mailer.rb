# frozen_string_literal: true

class IssueMailer < ApplicationMailer
  def payin_failure(order, result_message)
    @order = order
    @user = order.user
    @result_message = result_message

    mail(
      to:         "support@asanasano.com",
      subject:    "Echec paiement - User: #{@user.id} - séance de #{@order.slot.course.name}
                  du #{@order.slot.date}!"
    )
  end
end
