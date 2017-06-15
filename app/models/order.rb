# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  state        :integer
#  slot_id      :integer
#  amount_cents :integer          default(0), not null
#  payment      :json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_orders_on_slot_id  (slot_id)
#

class Order < ApplicationRecord
  monetize :amount_cents
  belongs_to :slot

  enum state: [ :pending, :paid ]
end
