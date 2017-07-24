class Users::InvitationsController < Devise::InvitationsController
  # def update
    # if some_condition
    #   redirect_to root_path
    # else
    #   super
    # end
  # end

  before_action :find_group, only: :create

  # POST /resource/invitation
  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, :email => self.resource.email
      end
      if self.method(:after_invite_path_for).arity == 1
        respond_with resource, :location => after_invite_path_for(current_inviter)
      else
        respond_with resource, :location => after_invite_path_for(current_inviter, resource)
      end

      # group tracking
      self.resource.groups.push(@group)

    else
      respond_with_navigational(resource) { render :new }
    end

  end


private

  def find_group
    @group = Group.find(params[:user][:group_id])
  end

end
