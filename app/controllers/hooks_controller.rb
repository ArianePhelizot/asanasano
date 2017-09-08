class HooksController < ApplicationController

skip_before_action :authenticate_user!

before_action :set_mangopay_order, only: [:payment_succeeded,
                                          :payment_failed,
                                          :set_user,
                                          :order_state_changed_to_paid,
                                          :user_feedback_on_booking_and_payment]

before_action :set_mangopay_order_to_refund, only: [:payin_refund_succeeded,
                                                    :payin_refund_failed]

before_action :set_mangopay_order_to_transfer, only: [:transfer_normal_succeded,
                                                    :transfer_normal_failed]

before_action :set_user, only: [:payment_succeeded, :order_state_changed_to_paid,
                                :user_feedback_on_booking_and_payment,
                                :payment_failed,
                                :payin_refund_succeeded,
                                :payin_refund_failed,
                                :transfer_normal_succeded,
                                :transfer_normal_failed]

before_action :set_log_error, only: [:payment_succeeded,
                                     :payment_failed,
                                     :payin_refund_succeeded,
                                     :payin_refund_failed,
                                     :transfer_normal_succeded,
                                     :transfer_normal_failed]

  def payment_succeeded
    # log_hook_notification
    order_state_changed_to_paid

    render nothing: true, status: 204 # answer to API

    rescue MangoPay::ResponseError => ex
      log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "payment_succeeded",
                         mangopay_answer: "Mangopay HOOK - EventType: #{params["EventType"]},
                                          RessourceId: #{params["RessourceId"]},
                                          Date: #{params["Date"]}",
                         user_id: @user.id.to_i,
                         error_logs: log_error)
  end

  def order_state_changed_to_paid
    authorize @order
    @order.state = "paid"
    @order.save!

    unless @order.slot.users.include?(@user)
      @order.slot.users.push(@user)
    end

    user_feedback_on_booking_and_payment
  end

  def user_feedback_on_booking_and_payment
    flash[:notice] = "Vous êtes bien inscrit à la séance #{l(@order.slot.date, format: :long)}."

    # Mail de confirmation à envoyer
    OrderMailer.order_confirmation(@user, @order).deliver_now
  end

  def payment_failed
    # log_hook_notification
    @order = Order.find_by(mangopay_id: params["RessourceId"])
    authorize @order
    @order.state = "failed"
    @order.save!

    render nothing: true, status: 204

    rescue MangoPay::ResponseError => ex
        log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "payment_failed",
                         mangopay_answer: "Mangopay HOOK - EventType: #{params["EventType"]},
                                          RessourceId: #{params["RessourceId"]},
                                          Date: #{params["Date"]}",
                         user_id: @user.id.to_i,
                         error_logs: log_error)
  end


  def payin_refund_succeeded
    begin
      authorize @order
      @order.state = "refunded"
      @order.settled = true
      @order.save!

      render nothing: true, status: 204 # answer to API

    rescue MangoPay::ResponseError => ex
      log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "payin_refund_succeeded",
                         mangopay_answer: "Mangopay HOOK - EventType: #{params["EventType"]},
                                          RessourceId: #{params["RessourceId"]},
                                          Date: #{params["Date"]}",
                         user_id: @user.id.to_i,
                         error_logs: log_error)
     end
      # Mail ad'hoc
      OrderMailer.slot_cancellation_with_refund_confirmation(@user, @order).deliver_now
  end

  def payin_refund_failed
    authorize @order
    @order.state = "failed_refund"
    @order.save!

    render nothing: true, status: 204 # answer to API

    rescue MangoPay::ResponseError => ex
      log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "payin_refund_failed",
                         mangopay_answer: "Mangopay HOOK - EventType: #{params["EventType"]},
                                          RessourceId: #{params["RessourceId"]},
                                          Date: #{params["Date"]}",
                         user_id: @user.id.to_i,
                         error_logs: log_error)
  end

  def transfer_normal_succeded
    # Need to identify order first
    # Need to pass order.settled to true
    authorize @order
    @order.settled = true
    @order.save
    # Need to log the info in MangopayLog table
    render nothing: true, status: 204 # answer to API

    rescue MangoPay::ResponseError => ex
      log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "transfer_succeeded",
                         mangopay_answer: "Mangopay HOOK - EventType: #{params["EventType"]},
                                          RessourceId: #{params["RessourceId"]},
                                          Date: #{params["Date"]}",
                         user_id: @user.id.to_i,
                         error_logs: log_error)

  end

  def transfer_normal_failed

    render nothing: true, status: 204 # answer to API

    rescue MangoPay::ResponseError => ex
      log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "transfer_failed",
                         mangopay_answer: "Mangopay HOOK - EventType: #{params["EventType"]},
                                          RessourceId: #{params["RessourceId"]},
                                          Date: #{params["Date"]}",
                         user_id: @user.id.to_i,
                         error_logs: log_error)
  end

  def payout_normal_succeded
    # Need to identify payout first
    # Identify the slot and pass its status to "archived"
    # Beware of slot policy!
    # Log info in mangopay log
  end

  def payout_normal_failed
  end

  def set_mangopay_order
    @order = Order.find_by(mangopay_id: params["RessourceId"])
  end

  def set_mangopay_order_to_refund
    @order = Order.find_by(refund_mangopay_id: params["RessourceId"])
  end

  def set_mangopay_order_to_transfer
    @order = Order.find_by(transfer_mangopay_id: params["RessourceId"])
  end

  def set_user
    @user = @order.user
  end

  def set_log_error
    log_error = nil
  end

  # def log_hook_notification
  #   MangopayLog.create(event: "card_web_pay_in_creation",
  #                         mangopay_answer: mangopay_card_web_pay_in,
  #                         user_id: current_user.i
  # end

end
