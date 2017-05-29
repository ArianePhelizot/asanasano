module ApplicationHelper

  def is_full?(slot)
    slot.users.count == slot.course.capacity_max
  end

end
