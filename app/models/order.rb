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

  enum state: %i(pending paid failed ask_for_refund refund_for_slot_cancellation
                 failed_refund refunded)

  after_create :send_new_order_slack_notification

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable LineLength
  def mangopay_order_tag
    " - Order: #{id} - User: #{user.id}, #{user.first_name.first}.#{user.last_name} -Slot: #{slot.id} du #{slot.date.strftime('%d/%m/%y')} - Course: #{slot.course.id}, #{slot.course.name} - Coach: #{slot.course.coach_id}/User_id: #{slot.course.coach.user.id}, #{slot.course.coach.user.first_name.first}.#{slot.course.coach.user.last_name} "
  end

  def send_new_order_slack_notification
    require "slack-notifier"
    notifier = Slack::Notifier.new "https://hooks.slack.com/services/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"
    notifier.ping "Awsome new order for #{slot.course.name} from #{user.email} - #{Rails.application.class.parent_name} - #{Rails.env}"
  end
  # rubocop:enable LineLength
  # rubocop:enable Metrics/AbcSize
end
