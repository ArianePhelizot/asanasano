# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :set_order, only: :new

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable UselessAssignment
  def new
    # On passe @order en argument de la méthode authorize car on n'a pas de modèle payment.
    # la méthode authorize s'exécute dans le fichier (payment_policy.rb)
    authorize @order
    # On créée un card web payin

    mangopay_card_web_pay_in = MangoPay::PayIn::Card::Web.create(
      "Tag": current_user.account.tag,
      "AuthorId": current_user.account.mangopay_id,
      "CreditedUserId": current_user.account.mangopay_id,
      "DebitedFunds": { "Currency": "EUR", "Amount": @order.amount_cents },
      "Fees": { "Currency": "EUR", "Amount": 0 },
      "ReturnUrl": default_url_options_for_mangopay[:host] + "/courses/" +
                    @order.slot.course.id.to_s,
      "CreditedWalletId": current_user.account.wallet.mangopay_id,
      "CardType": "CB_VISA_MASTERCARD",
      "SecureMode": "DEFAULT",
      "Culture": "FR",
      "StatementDescription": "ASANASANO"
    )

    # j'enregistre le json de réponse dans mon order
    @order.update(payment: mangopay_card_web_pay_in)
    @order.state = "pending"
    @order.mangopay_id = mangopay_card_web_pay_in["Id"]
    @order.save!
    # si statut retour = success => @order.state = "paid"
    # si statut retour = success => @order.state = "failed"

    # =========================A voir où mettre????--======================
    # Petit audit des hooks créés
    # Liste des hooks existants
    mangopayhooks = MangoPay::Hook.fetch("page" => 1, "per_page" => 1)

    # Check si hook créé pour l'événement "PAYIN_NORMAL_SUCCEEDED"
    # Si le nb de hook pour "PAYIN_NORMAL_SUCCEEDED" < 1
    if mangopayhooks.select { |hash| hash.value?("PAYIN_NORMAL_SUCCEEDED") }.empty?
      # Alors il faut crée un hook
      payment_succeeded_hook = MangoPay::Hook.create(
        "EventType": "PAYIN_NORMAL_SUCCEEDED",
        "Url": default_url_options_for_mangopay[:host] + "/orders/payment_succeeded/"
      )
    end

    # Check si hook créé pour l'événement "PAYIN_NORMAL_FAILED"
    # Si le nb de hook pour "PAYIN_NORMAL_FAILED" < 1
    if mangopayhooks.select { |hash| hash.value?("PAYIN_NORMAL_SUCCEEDED") }.empty?
      payment_failed_hook = MangoPay::Hook.create(
        "EventType": "PAYIN_NORMAL_FAILED",
        "Url": default_url_options_for_mangopay[:host] + "/orders/payment_failed/"
      )
    end

    # =========================FIN DE A voir où mettre????--======================

    # @order.update(payment: charge.to_json, status: "paid")
    #     @order.slot.users.push(current_user)
    #     flash[:notice] = "Vous êtes bien inscrit à la séance
    # {l(@order.slot.date, format: :long)}."

    #     # Rajouter ici le mail de confirmation à envoyer
    #     OrderMailer.order_confirmation(current_user, @order).deliver_now

    redirect_to mangopay_card_web_pay_in["RedirectURL"] # ouvre la page pour saisie CB
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable UselessAssignment

  # code Collin======================================
  # payment controller
  # def hook_succeeded
  #   order = Order.find_by_payment_id!(params[:RessourceId])

  #   # order.status = :paid
  #   # order.save!

  #   order.paid!

  #   render nothing: true, status: 204
  # rescue => ex
  #   text = "Erreur dans une réception de ACK MangoPay: *#{ex.message}*"

  #   raise ex
  # end

  # def hook_failed
  #   order = Order.find_by_payment_id!(params[:RessourceId])

  #   # order.status = :payment_failed
  #   # order.save!
  #   order.payment_failed!

  #   render nothing: true, status: 204
  # rescue => ex
  #   text = "Erreur dans une réception de ACK MangoPay: *#{ex.message}*"

  #   raise ex
  # end
  # ======================================================

  private

  def set_order
    @order = Order.where(state: "pending").find(params[:order_id])
  end
end

# # ANCIEN CODE MANGOPAY CARDREGISTRATION DANS LE CAS  DIRECT payment_policy
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

# ANCIEN CODE AVEC STRIPE=========================================================
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
