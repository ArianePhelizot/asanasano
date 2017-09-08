# frozen_string_literal: true

class OrdersController < ApplicationController

  # before_action :set_mangopay_order, only: [:payment_succeeded,
  #                                           :payment_failed,
  #                                           :set_user,
  #                                           :order_state_changed_to_paid,
  #                                           :user_feedback_on_booking_and_payment]
  # before_action :set_user, only: [:payment_succeeded, :order_state_changed_to_paid,
  #                                 :user_feedback_on_booking_and_payment]

  def show
    @order = Order.where(state: "paid").find(params[:id])
    authorize @order
  end

  def create
    @slot = Slot.find(params[:slot_id])
    order = Order.new(user: current_user, slot: @slot, amount: @slot.price, state: :pending)
    authorize order
    if order.save
      redirect_to new_order_payment_path(order)
    else
      render courses / show
    end
  end

  # def payment_succeeded
  #   order_state_changed_to_paid

  #   render nothing: true, status: 204 # answer to API

  #   rescue MangoPay::ResponseError => ex
  #     log_error = ex.message
  #   rescue => ex
  #     log_error = ex.message
  #   ensure
  #     MangopayLog.create(event: "payment_succeeded",
  #                        user_id: @user.id.to_i,
  #                        error_logs: log_error)
  # end

  # def order_state_changed_to_paid
  #   authorize @order
  #   @order.state = "paid"
  #   @order.save!

  #   @order.slot.users.push(@user)
  #   user_feedback_on_booking_and_payment
  # end

  # def user_feedback_on_booking_and_payment
  #   flash[:notice] = "Vous êtes bien inscrit à la séance #{l(@order.slot.date, format: :long)}."

  #   # Mail de confirmation à envoyer
  #   OrderMailer.order_confirmation(@user, @order).deliver_now
  # end

  # def payment_failed
  #   @order = Order.find_by(mangopay_id: params["RessourceId"])
  #   authorize @order
  #   @order.state = "failed"
  #   @order.save!

  #   render nothing: true, status: 204

  #   rescue MangoPay::ResponseError => ex
  #       log_error = ex.message
  #   rescue => ex
  #     log_error = ex.message
  #   ensure
  #     MangopayLog.create(event: "payment_failed",
  #                        user_id: @user.id.to_i,
  #                        error_logs: log_error)
  # end

  # private

  # def set_mangopay_order
  #   @order = Order.find_by(mangopay_id: params["RessourceId"])
  # end

  # def set_user
  #   @user = @order.user
  # end
end
