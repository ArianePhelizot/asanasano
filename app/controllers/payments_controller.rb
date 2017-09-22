# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :set_order, only: :new

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def new
    # Launch mangopayhooks creation if no hooks created yet
    MangopayHookJob.perform_now

    # On passe @order en argument de la méthode authorize car on n'a pas de modèle payment.
    # la méthode authorize s'exécute dans le fichier (payment_policy.rb)
    authorize @order
    # On créée un card web payin

    begin
      log_error = nil

      mangopay_card_web_pay_in = MangoPay::PayIn::Card::Web.create(
        "Tag": @order.mangopay_order_tag,
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
    rescue MangoPay::ResponseError => ex
      log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "card_web_pay_in_creation",
                         mangopay_answer: mangopay_card_web_pay_in,
                         user_id: current_user.id.to_i,
                         error_logs: log_error)
    end

    if mangopay_card_web_pay_in["ResultMessage"].nil?
      redirect_to mangopay_card_web_pay_in["RedirectURL"] # ouvre la page pour saisie CB
      sleep(5.0)
      flash[:notice] = "Bien reçu. Votre commande est en cours de traitement!."
    else
      redirect_to course_path(@order.slot.course)
      flash[:alert] = "Arghhh, nous avons eu un problème sur le traitement de votre commande."
      IssueMailer.payin_failure(@order, mangopay_card_web_pay_in["ResultMessage"]).deliver_now
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
    # @order = Order.where(state: "pending").find(params[:order_id])
  end
end

#   # rubocop:enable Metrics/AbcSize
#   # rubocop:enable Metrics/MethodLength
