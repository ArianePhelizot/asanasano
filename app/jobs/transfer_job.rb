class TransferJob < ApplicationJob
  queue_as :default

  ASANASANO_FEES_RATE_ON_WALLET_TRANSFER = 0
  # où et quand définit-on quand on souhaite que l'opération soit effectuée ?
  # BEWARE: Arguments will be serialized to json, so pass id, string, not full objects.

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def perform
    # Once a day, I want to transfer money from customers wallets to coaches wallets
    # for all new "passed" slots, i.e for "passed" slots
    # whose "paid" orders haven't been "settled" yet

    # selection of all passed slots with paid but not yet settled orders
    paid_orders = Order.all.where(state: "paid")
    paid_orders_of_passed_slots = paid_orders.select { |order| order.slot.status == "passed" }
    # rubocop:disable LineLength
    paid_orders_of_passed_slots_to_settle = paid_orders_of_passed_slots.select { |order| order.settled == false }
    # rubocop:enable LineLength

    paid_orders_of_passed_slots_to_settle.each do |order|
      slot = order.slot
      user = order.user
      coach_user = slot.course.coach.user
      # check first that customer did not cancel his attendance to slot
      if slot.users.include?(user)
      # if yes ask for transferring money from customer wallet to coach wallet


        begin
          mangopay_transfer = MangoPay::Transfer.create(
            "Tag": "Money transfer",
            # "Tag": "Money transfer from user_id:#{user.id}
            # to coach user_id:#{coach_user.id}, slot_id: #{slot.id}",
            # "AuthorId": ENV["MANGOPAY_CLIENT_ID"], author has to be the wallet owner!!!
            "AuthorId": user.account.mangopay_id,
            "CreditedUserId": user.account.mangopay_id,
            "DebitedFunds": { "Currency": "EUR",
                              "Amount": order.amount_cents * (1 - ASANASANO_FEES_RATE_ON_WALLET_TRANSFER) },
            "Fees": { "Currency": "EUR",
                      "Amount": order.amount_cents * ASANASANO_FEES_RATE_ON_WALLET_TRANSFER },
            "DebitedWalletId": user.account.wallet.mangopay_id,
            "CreditedWalletId": coach_user.account.wallet.mangopay_id
          )

          order.transfer_mangopay_id = mangopay_transfer["Id"]
          order.save

        rescue MangoPay::ResponseError => ex
          log_error = ex.message
        rescue => ex
            log_error = ex.message
        ensure
             MangopayLog.create(event: "transfer_creation",
                            mangopay_answer: mangopay_transfer,
                            user_id: user.id.to_i,
                            error_logs: log_error)
        end
      end
    end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  end
end

