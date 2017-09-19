# frozen_string_literal: true

class SlotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user_is_group_owner_or_coach?
  end

  def update?
    user_is_group_owner_or_coach?
  end

  def desinscription_from_course_page?
    record.users.include?(user)
  end

  def desinscription_from_dashboard?
    desinscription_from_course_page?
  end

  def destroy?
    user_is_group_owner_or_coach?
  end

  def payout_normal_succeeded?
    true
  end

  def payout_normal_failed?
    payout_normal_succeeded?
  end

  # on teste ici si le user est le créateur du groupe ou le coach du cours.
  def user_is_group_owner_or_coach?
    record.course.group.owner == user || record.course.coach == user
  end
end
