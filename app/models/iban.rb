# == Schema Information
#
# Table name: ibans
#
#  id          :integer          not null, primary key
#  account_id  :integer
#  mangopay_id :integer
#  tag         :string
#  iban        :string
#  active      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_ibans_on_account_id  (account_id)
#

class Iban < ApplicationRecord
  belongs_to :account
end
