# frozen_string_literal: true

class CoachPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def update?
    record.user == user # seul le coach peut modifier son profil de coach
  end
end
