# == Schema Information
#
# Table name: mangopay_logs
#
#  id              :integer          not null, primary key
#  event           :string
#  user_id         :integer
#  mangopay_answer :string
#  error_logs      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_mangopay_logs_on_user_id  (user_id)
#

class MangopayLog < ApplicationRecord
  validates :event, inclusion: { in: %w(natural_account_creation
                                        legal_account_creation
                                        wallet_creation
                                        iban_creation
                                        natural_account_update
                                        legal_account_update
                                        card_web_pay_in_creation
                                        payment_succeeded
                                        payment_failed
                                        refund_creation
                                        payin_refund_succeeded
                                        payin_refund_failed
                                        transfer_creation
                                        payout_creation
                                        payout_succeeded
                                        payout_failed) }
end
