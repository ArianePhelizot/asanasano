# class TransferJob < ApplicationJob
#   queue_as :default

#   ASANASANO_FEES_RATE = 0.1
# # où et quand définit-on quand on souhaite que l'opération soit effectuée ?
# # BEWARE: Arguments will be serialized to json, so pass id, string, not full objects.

#   def perform(order_id)

#     slot = Order.find(order_id).slot
#     montant = Order.find(order_id).amount_cents
#     user = Order.find(order_id).user
#     coach_user = slot.course.coach.user

#     # valider que le user est bien toujours un particpant du cours et donc qu'il n'a pas annulé
#     # que le cours n'a pas été annulé
#     # que le cours est bien passé (date antérieure), histoire d'anticiper un éventuel report


#     if slot.users.include?(user)&& slot.status == "passed"
#       mangopay_transfer = MangoPay::Transfer.create(
#         "Tag": "Money transfer from user_id:#{user.id} to coach user_id#{coach_user.id},
#                 slot_id: #{slot.id}",
#         "AuthorId": ENV["MANGOPAY_CLIENT_ID"],
#         "CreditedUserId": user.account.mangopay_id,
#         "DebitedFunds": {"Currency": "EUR",
#                           "Amount": order.amount_cents * (1-FEES)},
#         "Fees": {"Currency": "EUR",
#                   "Amount": order.amount_cents * FEES},
#         "DebitedWalletId": user.account.wallet,
#         "CreditedWalletId": coach_user.account.wallet
#         )
#     end

#   end

# end
