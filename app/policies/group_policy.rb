class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def update?
    user_is_group_owner?
  end

  def destroy?
    user_is_group_owner?
  end

  # on teste ici si le user est le créateur du group.
  def user_is_group_owner?
    record.owner == user
  end

  def group_participants?
    true
  end

  def remove_current_user_from_group?
    true
  end

 end
