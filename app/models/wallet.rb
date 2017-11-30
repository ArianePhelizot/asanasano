# == Schema Information
#
# Table name: wallets
#
#  id          :integer          not null, primary key
#  account_id  :integer
#  tag         :string
#  mangopay_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_wallets_on_account_id  (account_id)
#

class Wallet < ApplicationRecord
  belongs_to :account
  after_validation :report_validation_errors_to_rollbar
end
