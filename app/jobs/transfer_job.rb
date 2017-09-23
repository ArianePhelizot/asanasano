class TransferJob < ApplicationJob
  queue_as :default

  def perform
    # Once a day, I want to transfer money from customers wallets to coaches wallets

    # 1st STEP
    orders_to_settle = identify_orders_to_settle

    # 2nd STEP
    create_mangopay_transfers(orders_to_settle)
  end

  def identify_orders_to_settle
    # selection of all passed slots with paid but not yet settled orders
    paid_orders = Order.all.where(state: "paid")
    non_settled_paid_orders = paid_orders.select { |order| order.settled == false }
    orders_to_settle = non_settled_paid_orders.select { |order| order.slot.status == "passed" }
    orders_to_settle
  end

# rubocop:disable all
  def create_mangopay_transfers(orders_to_settle)
    orders_to_settle.each do |order|
      slot = order.slot
      user = order.user
      coach_user = slot.course.coach.user
      # check first that customer did not cancel his attendance to slot
      if slot.users.include?(user)
        # if yes ask for transferring money from customer wallet to coach wallet
        # it should be ok since now when somebody cancel a slot, the order is
        # settled wether there has been a refund or not
        call_mangopay_api_for_transfer_creation(order, slot, user, coach_user)
      end
    end
  end

  def call_mangopay_api_for_transfer_creation(order, _slot, user, coach_user)
    begin
      mangopay_transfer = MangoPay::Transfer.create(
        "Tag": order.mangopay_order_tag,
        # "Tag": "Money transfer from user_id:#{user.id}
        # to coach user_id:#{coach_user.id}, slot_id: #{slot.id}",
        # "AuthorId": ENV["MANGOPAY_CLIENT_ID"], author has to be the wallet owner!!!
        "AuthorId": user.account.mangopay_id,
        "CreditedUserId": user.account.mangopay_id,
        "DebitedFunds":
            { "Currency": "EUR",
              "Amount": order.amount_cents},
        "Fees": { "Currency": "EUR",
                  "Amount": 0},
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

    if mangopay_transfer["Status"] == "SUCCEEDED"
      order.settled = true
      order.save
    else
      IssueMailer.transfer_failed(order, mangopay_transfer["ResultMessage"]).deliver_now
    end
  end
  # rubocop:enable all
end
