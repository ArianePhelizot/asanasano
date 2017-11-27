# frozen_string_literal: true

class OrdersController < ApplicationController
  def show
    @order = Order.where(state: "paid").find(params[:id])
    authorize @order
  end

# rubocop:disable all
  def create # // code on hook controller
    @slot = Slot.find(params[:slot_id])
    order = Order.new(user: current_user, slot: @slot, amount: @slot.price, state: :pending)
    authorize order
    if order.save
      if order.amount == 0.to_money
        order.state = "paid"
        order.slot.users.push(current_user) unless order.slot.users.include?(current_user)
        order.save!
        flash[:notice] = "Vous êtes bien inscrit à la séance #{l(order.slot.date, format: :long)}."
        # Mail de confirmation à envoyer
        OrderMailer.order_confirmation(order).deliver_now
        redirect_to course_path(order.slot.course)
      else
        # redirect to mango payment page
        redirect_to new_order_payment_path(order)
      end
    else
      render courses / show
    end
  end
# rubocop:enable all
end
