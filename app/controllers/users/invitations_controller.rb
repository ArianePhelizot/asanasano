class Users::InvitationsController < Devise::InvitationsController
  # def update
    # if some_condition
    #   redirect_to root_path
    # else
    #   super
    # end
  # end



  # POST /resource/invitation
  def create


    #invite_resource déclenche l'envoi du mail. Comment du coup à la création, prendre en compte l'udate des groupes
    self.resource = invite_resource
    # group tracking
    self.resource.groups.push(find_group)

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

    else
      respond_with_navigational(resource) { render :new }
    end

  end


private

  def find_group
    @group = Group.find(params[:user][:group_id])
  end

end
