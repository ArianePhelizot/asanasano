# frozen_string_literal: true

class OrdersController < ApplicationController

skip_before_action :authenticate_user!, only: [:payment_succeeded, :payment_failed]

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

  def payment_succeeded
    @order = Order.find_by(mangopay_id: params["RessourceId"])
    authorize @order
    @order.state = "paid"
    @order.save!
    @order.slot.users.push(Account.find_by(mangopay_id: @order.payment["AuthorId"]).user)
    flash[:notice] = "Vous êtes bien inscrit à la séance #{l(@order.slot.date, format: :long)}."

#     # Rajouter ici le mail de confirmation à envoyer
#     OrderMailer.order_confirmation(current_user, @order).deliver_now

    render nothing: true, status: 204
  rescue => ex
    text = "Erreur dans une réception du paiement MangoPay: *#{ex.message}*"

    raise ex
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
end
