class CoachesPayoutJob < ApplicationJob
  queue_as :default

# rubocop:disable all
  def perform
    # Je regarde une fois par jour, pour chaque coach, l'ensemble des séances ayant eu
    # ... lieu il y a x jours où x = payout_delay_in_days

    Coach.all.each do |coach|
      coach_payout_period = coach.params_set.payout_delay_in_days

      # Je prends tous les slots d'un coach
      coach_slots = []
      coach.courses.each do |course|
        coach_slots << course.slots.to_a
      end
      coach_slots = coach_slots.flatten
      # Je veux virer l'argent du wallet des profs sur leur compte en banque pour
      # les cours qui ont eu lieu, il y a X jours, x = payout_delay_in_days

      # Liste de toutes les séances d'il y a 3 jours
      # only passed since we want to exclude cancelled and archived ones!
      coach_slots_to_payout = coach_slots.select { |slot| slot.date == Date.today - coach_payout_period.days }
      coach_slots_to_payout = coach_slots_to_payout.select { |slot| slot.status == "passed" }

      # Je regarde pour chacune de ces séances, quel était le coach
      coach_slots_to_payout.each do |slot|
        coach_payout(slot)
      end
    end
  end

  def coach_payout(slot)
    coach_user = slot.course.coach.user
    fees = slot.course.coach.params_set.fees_on_payout

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
              "Tag": slot.mangopay_payout_tag,
              "AuthorId": ENV["MANGOPAY_CLIENT_ID"],
              "DebitedFunds": {
                "Currency": "EUR",
                "Amount": billed_sum_cents * (1 - fees)
              },
              "Fees": {
                "Currency": "EUR",
                "Amount": billed_sum_cents * fees
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

          unless mangopay_payout["ResultMessage"].nil?
            IssueMailer.payout_failure(slot, mangopay_payout["ResultMessage"]).deliver_now
          end
        end
      end
    end
  end
# rubocop:enable all
end
