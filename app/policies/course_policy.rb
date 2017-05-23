class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user_is_group_owner?
  end

  def update?
    user_is_group_owner_or_coach?
  end

  def destroy?
    user_is_group_owner?
  end

  def show
    # TO DO: check if user is member of the group
    true
  end

  # on teste ici si le user est le créateur du group.
  def user_is_group_owner?
    record.group.owner == user
  end

  def user_is_group_owner_or_coach?
    record.group.owner == user || record.coach == user
  end
end
