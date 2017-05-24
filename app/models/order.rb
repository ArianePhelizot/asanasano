# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  state        :string
#  slot_sku     :string
#  amount_cents :integer          default("0"), not null
#  payment      :json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Order < ApplicationRecord
  monetize :amount_cents
end
