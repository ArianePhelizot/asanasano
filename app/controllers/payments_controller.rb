class PaymentsController < ApplicationController
  before_action :set_order

  def new
    # On passe @order en argument de la méthode authorize car on n'a pas de modèle payment.
    # la méthode authorize s'exécute dans le fichier (payment_policy.rb)
    authorize @order
  end

  def create
    authorize @order
    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @order.amount_cents, # or amount_pennies
      description:  "Paiement de la séance #{@order.slot.course.name} for order #{@order.id}",
      currency:     @order.amount.currency
    )

    @order.update(payment: charge.to_json, state: 'paid')
    @order.slot.users.push(current_user)
    redirect_to course_path(@order.slot.course)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_order_payment_path(@order)
  end

  private

  def set_order
    @order = Order.where(state: 'pending').find(params[:order_id])
  end
end
