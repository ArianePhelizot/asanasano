class TransferJob < ApplicationJob
  queue_as :default

  ASANASANO_FEES_RATE = 0.1
  # où et quand définit-on quand on souhaite que l'opération soit effectuée ?
  # BEWARE: Arguments will be serialized to json, so pass id, string, not full objects.

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def perform
    # Once a day, I want to transfer money from customers wallets to coaches wallets
    # for all new "passed" slots, i.e for "passed" slots
    # whose "paid" orders haven't been "settled" yet

    # selection of all passed slots, paid but non stelled orders
    paid_orders = Order.all.where(state: "paid")
    paid_orders_of_passed_slots = paid_orders.select { |order| order.slot.status == "passed" }
    # rubocop:disable LineLength
    paid_orders_of_passed_slots_to_settle = paid_orders_of_passed_slots.select { |order| order.settled == false }
    # rubocop:enable LineLength

    paid_orders_of_passed_slots_to_settle.each do |order|
      slot = order.slot
      user = order.user
      coach_user = slot.course.coach.user
      # check first that customer did not cancell his attendance to slot
      next unless slot.users.include?(user)
      # if yes ask for transferring money from customer wallet to coach walle
      # rubocop:disable UselessAssignment
      mangopay_transfer = MangoPay::Transfer.create(
        "Tag": "Money transfer",
        # "Tag": "Money transfer from user_id:#{user.id}
        # to coach user_id:#{coach_user.id}, slot_id: #{slot.id}",
        # "AuthorId": ENV["MANGOPAY_CLIENT_ID"], author has to be the wallet owner!!!
        "AuthorId": user.account.mangopay_id,
        "CreditedUserId": user.account.mangopay_id,
        "DebitedFunds": { "Currency": "EUR",
                          "Amount": order.amount_cents * (1 - ASANASANO_FEES_RATE) },
        "Fees": { "Currency": "EUR",
                  "Amount": order.amount_cents * ASANASANO_FEES_RATE },
        "DebitedWalletId": user.account.wallet.mangopay_id,
        "CreditedWalletId": coach_user.account.wallet.mangopay_id
      )
      # rubocop:enable UselessAssignment
      # ATTENTION IL FAUDRAIT ICI QUE J'INTEGRE LA REPONSE DE MANGOPAY
      # update order state
      order.settled = true
      order.save
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
