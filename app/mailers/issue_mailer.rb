# frozen_string_literal: true

class IssueMailer < ApplicationMailer
  ASANASANO_SUPPORT_TEAM_EMAIL = "support@asanasano.com"

  def payin_failure(order, result_message)
    @order = order
    @user = order.user
    @result_message = result_message

    mail(
      to:         ASANASANO_SUPPORT_TEAM_EMAIL,
      subject:    "Echec paiement - User: #{@user.id} - séance de #{@order.slot.course.name}
                  du #{@order.slot.date}!"
    )
  end

  def payin_refund_failed(order, result_message)
    @order = order
    @user = order.user
    @result_message = result_message

    mail(
      to:         ASANASANO_SUPPORT_TEAM_EMAIL,
      subject:    "Echec remboursement - User: #{@user.id} - séance de #{@order.slot.course.name}
                  du #{@order.slot.date}!"
    )
  end

  def transfer_failed(order, result_message)
    @order = order
    @user = order.user
    @result_message = result_message

    mail(
      to:         ASANASANO_SUPPORT_TEAM_EMAIL,
      subject:    "Echec Transfert - User: #{@user.id} - séance de #{@order.slot.course.name}
                  du #{@order.slot.date}!"
    )
  end
end
