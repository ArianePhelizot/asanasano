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

  validates_format_of :iban, with: /^[a-zA-Z]{2}\d{2}\s*(\w{4}\s*){2,7}\w{1,4}\s*$/, multiline: true

  def hidden_iban
    start = iban[0, 4]
    rest = iban[5, iban.length]
    hidden_rest = rest.chars.map! { |_c| "*" }
    start + hidden_rest.join("")
  end
end
