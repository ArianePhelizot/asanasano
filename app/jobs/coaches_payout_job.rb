class CoachesPayoutJob < ApplicationJob
  queue_as :default

  # Parametring the payment period from slot date to coach payout date
  COACH_PAYOUT_PERIOD = 3 # days

  ASANASANO_FEES_RATE_ON_PAYOUTS = 0.1

  # Je pense que je suis obligée de le gérer avec un mock-up de réponse d'API
  # et également d'intégrer dans mes fixtures des fake données d'API

  def perform
    # Je veux virer l'argent du wallet des profs sur leur compte en banque pour
    # les cours qui ont eu lieu, il y a 3 jours

    # Liste de toutes les séances d'il y a 3 jours
    slots = Slot.all.select { |slot| slot.date == Date.today - COACH_PAYOUT_PERIOD.days }
    slots = slots.select { |slot| slot.status == "passed" } # neither cancelled, nor archived!

    # Je regarde pour chacune de ces séances, quel était le coach
    slots.each do |slot|
      coach_payout(slot)
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def coach_payout(slot)
    coach_user = slot.course.coach.user
    if coach_user.account.present? && coach_user.account.iban.present?
      # je regarde quelle est la somme associée aux orders paid & settled du slots
      paid_orders = slot.orders.select { |order| order.state == "paid" }
      # rubocop:enable UselessAssignment
      paid_and_settled_orders = paid_orders.select { |order| order.settled = true }

       unless paid_and_settled_orders.empty?
        billed_amounts_array = paid_and_settled_orders.map(&:amount_cents)
        billed_sum_cents = billed_amounts_array.reduce(:+)

        # et je fais le virement correspondant au prof
        if billed_sum_cents.positive?
          begin
            mangopay_payout = MangoPay::PayOut::BankWire.create(
              "Tag": "Payout",
              "AuthorId": ENV["MANGOPAY_CLIENT_ID"],
              "DebitedFunds": {
                "Currency": "EUR",
                "Amount": billed_sum_cents * (1 - ASANASANO_FEES_RATE_ON_PAYOUTS)
              },
              "Fees": {
                "Currency": "EUR",
                "Amount": billed_sum_cents * (1 - ASANASANO_FEES_RATE_ON_PAYOUTS)
              },
              "BankAccountId": coach_user.account.iban.mangopay_id,
              "DebitedWalletId": coach_user.account.wallet.mangopay_id,
              "BankWireRef": "Séance #{slot.course.name} du #{slot.date.strftime('%v')}"
            )

            slot.payout_mangopay_id = mangopay_payout["Id"]
            slot.save
          rescue MangoPay::ResponseError => ex
            log_error = ex.message
          rescue => ex
            log_error = ex.message
          ensure
            MangopayLog.create(event: "payout_creation",
                               mangopay_answer: mangopay_payout,
                               user_id: coach_user.id.to_i,
                               error_logs: log_error)
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
