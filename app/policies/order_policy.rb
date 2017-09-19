# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    record.slot.course.group.users.include?(user)
  end

  def payment_succeeded?
    true
  end

  def payment_failed?
    payment_succeeded?
  end

  def payin_refund_succeeded?
    payment_succeeded?
  end

  def payin_refund_failed?
    payment_succeeded?
  end

  def desinscription?
    payment_succeeded?
  end
end
