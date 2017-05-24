class OrdersController < ApplicationController
  def show
    @order = Order.where(state: 'paid').find(params[:id])
  end

  def create
    @slot = Slot.find(params[:slot_id])
    order  = Order.create!(slot_sku: @slot.sku, amount: @slot.price, state: 'pending')

    redirect_to new_order_payment_path(order)
  end
end
