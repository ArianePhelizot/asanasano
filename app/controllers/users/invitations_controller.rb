class Users::InvitationsController < Devise::InvitationsController

  def invite_resource
    # group tracking
    super do |u|
      u.groups.push(find_group)
    end
  end


private

  def find_group
    @group = Group.find(params[:user][:group_id])
  end

end
