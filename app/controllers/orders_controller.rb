# frozen_string_literal: true

class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:payment_succeeded, :payment_failed]
  before_action :set_mangopay_order, only: [:payment_succeeded,
                                            :payment_failed,
                                            :set_user,
                                            :order_state_changed_to_paid,
                                            :user_feedback_on_booking_and_payment]
  before_action :set_user, only: [:payment_succeeded, :order_state_changed_to_paid,
                                  :user_feedback_on_booking_and_payment]

  def show
    @order = Order.where(state: "paid").find(params[:id])
    authorize @order
  end

  def create
    @slot = Slot.find(params[:slot_id])
    order = Order.new(slot: @slot, amount: @slot.price, state: :pending)
    authorize order
    if order.save
      redirect_to new_order_payment_path(order)
    else
      render courses / show
    end
  end

  # rubocop:disable UselessAssignment
  def payment_succeeded
    order_state_changed_to_paid

    render nothing: true, status: 204
  rescue => ex
    text = "Erreur dans une réception du paiement MangoPay: *#{ex.message}*"
    raise ex
  end

  def order_state_changed_to_paid
    authorize @order
    @order.state = "paid"
    @order.save!

    @order.slot.users.push(@user)
    user_feedback_on_booking_and_payment
  end

  def user_feedback_on_booking_and_payment
    flash[:notice] = "Vous êtes bien inscrit à la séance #{l(@order.slot.date, format: :long)}."

    # Mail de confirmation à envoyer
    OrderMailer.order_confirmation(@user, @order).deliver_now
  end

  def payment_failed
    @order = Order.find_by(mangopay_id: params["RessourceId"])
    authorize @order
    @order.state = "failed"
    @order.save!

    render nothing: true, status: 204
  rescue => ex
    text = "Erreur dans une réception du paiement MangoPay: *#{ex.message}*"

    raise ex
  end
  # rubocop:enable UselessAssignment

  private

  def set_mangopay_order
    @order = Order.find_by(mangopay_id: params["RessourceId"])
  end

  def set_user
    @user = Account.find_by(mangopay_id: @order.payment["AuthorId"]).user
  end
end
