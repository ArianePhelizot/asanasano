# frozen_string_literal: true

class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    # record = @order => donné par la méthode authorize dans orders#new
    record.slot.course.group.users.include?(user)
  end
end
