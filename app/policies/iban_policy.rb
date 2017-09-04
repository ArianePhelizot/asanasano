class IbanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    record.account.user == user
  end

  def update?
    record.account.user == user
  end
end
