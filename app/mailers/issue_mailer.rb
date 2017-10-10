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
                  du #{l(@slot.start_at, format:"%A %e %B")}!"
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
                  du #{l(@slot.start_at, format:"%A %e %B")}!"
    )
  end

  def payout_failure(slot, result_message)
    @slot = slot
    @coach_user = @slot.course.coach.user
    @result_message = result_message

    mail(
      to:         ASANASANO_SUPPORT_TEAM_EMAIL,
      subject:    "Echec Payout - Coach_user_id: #{@coach_user.id},
                  #{@coach_user.first_name.first}.#{@coach_user.last_name} -
                  séance de #{@slot.course.name}
                  du #{l(@slot.start_at, format:"%A %e %B")}!"
    )
  end
end
