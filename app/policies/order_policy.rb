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
end
