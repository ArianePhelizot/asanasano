# frozen_string_literal: true

class OrdersController < ApplicationController
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
end
