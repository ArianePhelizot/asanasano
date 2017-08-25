# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :set_order


def new
  # On passe @order en argument de la méthode authorize car on n'a pas de modèle payment.
  # la méthode authorize s'exécute dans le fichier (payment_policy.rb)
  authorize @order
  # On créée un card web payin

  uri = URI.parse("http://localhost:3000/orders"+@order.id.to_s+"/payments/new")

.../payins/card/web/

  header = {'Content-Type': "application/json"}
  mangopay_card_web_pay_in =  {"Tag": current_user.account.tag,
        "AuthorId": current_user.account.mangopay_id,
        "CreditedUserId": @order.slot.course.coach.user.account.mangopay_id,
        "DebitedFunds": { "Currency":"EUR", "Amount": @order.amount_cents},
        "Fees": @order.amount_cents/10,
        "ReturnUrl": default_url_option[:host] + "/courses/" + @order.slot.course.id.to_s,
        "CreditedWalletId": @order.slot.course.coach.user.account.wallet.mangopay_id ,
        "CardType": "CB_VISA_MASTERCARD",
        "SecureMode": "DEFAULT",
        "Culture": "FR",
        "StatementDescription": "ASANASANO"}

  # Create the HTTP objects
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = mangopay_card_web_pay_in.to_json

  # Send the request
  response = http.request(request)

  # mangopay_card_web_pay_in = MangoPay::Web.create(
  #       "Tag": current_user.account.tag,
  #       "AuthorId": current_user.account.mangopay_id,
  #       "CreditedUserId": @order.slot.course.coach.user.account.mangopay_id,
  #       "DebitedFunds": { "Currency":"EUR", "Amount": @order.amount_cents},
  #       "Fees": @order.amount_cents/10,
  #       "ReturnUrl": default_url_option[:host] + "/courses/" + @order.slot.course.id.to_s,
  #       "CreditedWalletId": @order.slot.course.coach.user.account.wallet.mangopay_id ,
  #       "CardType": "CB_VISA_MASTERCARD",
  #       "SecureMode": "DEFAULT",
  #       "Culture": "FR",
  #       "StatementDescription": "ASANASANO",
  #     )

# j'enregistre le json de réponse dans mon order
  # @order.update(payment: mangopay_card_web_pay_in)
  # si statut retour = created => interroger toutes les minutes l'API
  # si statut retour = success => @order.state = "paid"
  # si statut retour = success => @order.state = "failed"

end

  private

  def set_order
    @order = Order.where(state: "pending").find(params[:order_id])
  end

end

# # ANCIEN CODE AVEC MANGOPAY POUR NOTAMMENT CREER UNE CARDREGISTRATION DANS LE CAS D'UN DIRECT payment_policy

#   # rubocop:disable Metrics/AbcSize
#   # rubocop:disable Metrics/MethodLength
#   def new
#     # On passe @order en argument de la méthode authorize car on n'a pas de modèle payment.
#     # la méthode authorize s'exécute dans le fichier (payment_policy.rb)
#     authorize @order
#     # On créée un objet CardRegistration
#     @card_registration = CardRegistration.new(
#       tag: current_user.account.tag,
#       account_id: current_user.account.id
#     )

#     @card_registration.save
#     # On envoie les infos requises à MangoPay pour créer la CardRegistration chez Mangopay
#     mangopay_card_registration = MangoPay::CardRegistration.create(
#       "Tag": @card_registration.tag,
#       "UserId": current_user.account.mangopay_id,
#       "Currency": "EUR"
#     )

#     # On enregistre les données ad'hoc retournées par l'API dans l'objet card_registration créé
#     @card_registration.mangopay_id = mangopay_card_registration["Id"]
#     @card_registration.access_key = mangopay_card_registration["AccessKey"]
#     @card_registration.preregistration_data = mangopay_card_registration["PreregistrationData"]
#     @card_registration.card_registration_url = mangopay_card_registration["CardRegistrationURL"]

#     @card_registration.save

#   end
#   # rubocop:enable Metrics/AbcSize
#   # rubocop:enable Metrics/MethodLength

#   private

#   def set_order
#     @order = Order.where(state: "pending").find(params[:order_id])
#   end
# end

# ANCIEN CODE AVEC STRIPE
#   def new
#     # On passe @order en argument de la méthode authorize car on n'a pas de modèle payment.
#     # la méthode authorize s'exécute dans le fichier (payment_policy.rb)
#     authorize @order
#   end
#   def create
#     authorize @order
#     customer = Stripe::Customer.create(
#       source: params[:stripeToken],
#       email:  params[:stripeEmail]
#     )

#     charge = Stripe::Charge.create(
#       customer:     customer.id, # You should store this customer id and re-use it.
#       amount:       @order.amount_cents, # or amount_pennies
#       description:  "Paiement de la séance #{@order.slot.course.name} for order #{@order.id}",
#       currency:     @order.amount.currency
#     )

#     @order.update(payment: charge.to_json, state: "paid")
#     @order.slot.users.push(current_user)
#     flash[:notice] = "Vous êtes bien inscrit à la séance #{l(@order.slot.date, format: :long)}."

#     # Rajouter ici le mail de confirmation à envoyer
#     OrderMailer.order_confirmation(current_user, @order).deliver_now

#     redirect_to course_path(@order.slot.course)
#   rescue Stripe::CardError => e
#     flash[:error] = e.message
#     redirect_to new_order_payment_path(@order)
#   end
#   # rubocop:enable Metrics/AbcSize
#   # rubocop:enable Metrics/MethodLength

#   private

#   def set_order
#     @order = Order.where(state: "pending").find(params[:order_id])
#   end
# end
