# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                   :integer          not null, primary key
#  state                :integer
#  slot_id              :integer
#  amount_cents         :integer          default(0), not null
#  payment              :json
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  mangopay_id          :integer
#  user_id              :integer
#  settled              :boolean          default(FALSE), not null
#  refund_mangopay_id   :integer
#  transfer_mangopay_id :integer
#
# Indexes
#
#  index_orders_on_slot_id  (slot_id)
#  index_orders_on_user_id  (user_id)
#

class Order < ApplicationRecord
  monetize :amount_cents
  belongs_to :slot
  belongs_to :user

  enum state: %i(pending paid failed ask_for_refund refund_for_slot_cancellation failed_refund refunded)

  def mangopay_order_tag
    " - Order: #{self.id} - User: #{self.user.id}, #{self.user.first_name.first}.#{self.user.last_name} -Slot: #{self.slot.id} du #{slot.date.strftime("%d/%m/%y")} - Course: #{self.slot.course.id}, #{self.slot.course.name} - Coach: #{self.slot.course.coach_id}/User_id: #{self.slot.course.coach.user.id}, #{self.slot.course.coach.user.first_name.first}.#{self.slot.course.coach.user.last_name} "
  end

end
