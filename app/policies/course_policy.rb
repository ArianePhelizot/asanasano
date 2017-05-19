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
    user_is_group_owner?
  end

  def destroy?
    user_is_group_owner?
  end

  # on teste ici si le user est le créateur du group.
  def user_is_group_owner?
    record.group.user == user
  end
end
