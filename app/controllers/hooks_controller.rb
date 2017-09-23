# rubocop:disable Metrics/ClassLength
class HooksController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_mangopay_order, only: [:payment_succeeded,
                                            :payment_failed,
                                            :set_user,
                                            :order_state_changed_to_paid,
                                            :user_feedback_on_booking_and_payment]

  before_action :set_mangopay_order_to_refund, only: [:payin_refund_succeeded,
                                                      :payin_refund_failed,
                                                      :login_refund_success_in_mangopay_logs]

  before_action :set_mangopay_slot_to_payout, only: [:payout_normal_succeeded,
                                                     :payout_normal_failed]

  before_action :set_user, only: [:payment_succeeded, :order_state_changed_to_paid,
                                  :user_feedback_on_booking_and_payment,
                                  :payment_failed,
                                  :payin_refund_failed]

  before_action :set_log_error, only: [:payment_succeeded,
                                       :payment_failed,
                                       :payin_refund_succeeded,
                                       :payin_refund_failed,
                                       :payout_normal_succeeded,
                                       :payout_normal_failed]

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength

  def payment_succeeded
    # log_hook_notification
    order_state_changed_to_paid

    render nothing: true, status: 200 # answer to API
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "payment_succeeded",
                       mangopay_answer: "Mangopay HOOK - EventType: #{params['EventType']},
                                        RessourceId: #{params['RessourceId']},
                                        Date: #{params['Date']}",
                       user_id: @user.id.to_i,
                       error_logs: log_error)
  end

  def order_state_changed_to_paid
    authorize @order
    @order.state = "paid"
    @order.save!

    @order.slot.users.push(@user) unless @order.slot.users.include?(@user)

    user_feedback_on_booking_and_payment
  end

  def user_feedback_on_booking_and_payment
    flash[:notice] = "Vous êtes bien inscrit à la séance #{l(@order.slot.date, format: :long)}."

    # Mail de confirmation à envoyer
    OrderMailer.order_confirmation(@order).deliver_now
  end

  def payment_failed
    # log_hook_notification
    @order = Order.find_by(mangopay_id: params["RessourceId"])
    authorize @order
    @order.state = "failed"
    @order.save!

    render nothing: true, status: 200
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "payment_failed",
                       mangopay_answer: "Mangopay HOOK - EventType: #{params['EventType']},
                                        RessourceId: #{params['RessourceId']},
                                        Date: #{params['Date']}",
                       user_id: @user.id.to_i,
                       error_logs: log_error)
  flash[:alert] = "Damned! Il y a eu un souci avec votre paiement.
                  Contactez-nous à #{ASANASANO_SUPPORT_TEAM_EMAIL}}
                  pour que nous trouvions ensemble une solution."

  end

  def payin_refund_succeeded
    login_refund_success_in_mangopay_logs
    # Log feedback API in MangopayLogs

    # Mail ad'hoc différent si annulation à l'initiative du prof/group owner ou du client final
    authorize @order

    if @order.state == "ask_for_refund"
      OrderMailer.slot_cancellation_with_refund_confirmation(@order).deliver_now
    elsif @order.state == "refund_for_slot_cancellation"
      OrderMailer.slot_cancellation_by_orga_information(@order).deliver_now
    else
      fail
    end

    # Change order.state
    @order.state = "refunded"
    @order.settled = true
    @order.save!
  end

  def login_refund_success_in_mangopay_logs
    render nothing: true, status: 200 # answer to API
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "payin_refund_succeeded",
                       mangopay_answer: "Mangopay HOOK - EventType: #{params['EventType']},
                                        RessourceId: #{params['RessourceId']},
                                        Date: #{params['Date']}",
                       user_id: @order.user.id.to_i,
                       error_logs: log_error)
  end

  def payin_refund_failed
    authorize @order
    @order.state = "failed_refund"
    @order.save!

    render nothing: true, status: 200 # answer to API
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "payin_refund_failed",
                       mangopay_answer: "Mangopay HOOK - EventType: #{params['EventType']},
                                        RessourceId: #{params['RessourceId']},
                                        Date: #{params['Date']}",
                       user_id: @user.id.to_i,
                       error_logs: log_error)
  end

  def payout_normal_succeeded
    # Need to identify payout first
    # Identify the slot and pass its status to "archived"
    authorize @slot
    @slot.status = "archived"
    @slot.save
    # Beware of slot policy!
    render nothing: true, status: 200 # answer to API

    # Log info in mangopay log
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "payout_succeeded",
                       mangopay_answer: "Mangopay HOOK - EventType: #{params['EventType']},
                                        RessourceId: #{params['RessourceId']},
                                        Date: #{params['Date']}",
                       user_id: @slot.course.coach.user.id.to_i,
                       error_logs: log_error)
  end

  def payout_normal_failed
    render nothing: true, status: 200 # answer to API

    # Log info in mangopay log
  rescue MangoPay::ResponseError => ex
    log_error = ex.message
  rescue => ex
    log_error = ex.message
  ensure
    MangopayLog.create(event: "payout_failed",
                       mangopay_answer: "Mangopay HOOK - EventType: #{params['EventType']},
                                        RessourceId: #{params['RessourceId']},
                                        Date: #{params['Date']}",
                       user_id: @slot.course.coach.user.id.to_i,
                       error_logs: log_error)
  end

  def set_mangopay_order
    @order = Order.find_by(mangopay_id: params["RessourceId"])
  end

  def set_mangopay_order_to_refund
    @order = Order.find_by(refund_mangopay_id: params["RessourceId"])
  end

  def set_mangopay_slot_to_payout
    @slot = Slot.find_by(payout_mangopay_id: params["RessourceId"])
  end

  def set_user
    @user = @order.user
  end

  def set_log_error
    # rubocop:disable UselessAssignment
    log_error = nil
    # rubocop:enable UselessAssignment
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end

# rubocop:enable Metrics/ClassLength
