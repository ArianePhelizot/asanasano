# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  before_action :update_sanitized_params, only: :update

  # rubocop:disable all
  def invite_resource(&block)
    # je regarde si je connais l'adresse email
    @user = User.find_by(email: invite_params[:email])

    # si le user existe et n'appartient pas déjà au groupe
    if @user && !@user.groups.include?(find_group)
      @user.groups.push(find_group)
      for_coaches_only
      # invite! instance method returns a Mail::Message instance
      # User.invite_existing_user!({:email => @user.email}, current_user)
      User.invite_existing_user!({:email => @user.email}, current_user)
      # return the user instance to match expected return type

    # si le user existe et appartient déjà au groupe
    elsif @user && @user.groups.include?(find_group)
      for_coaches_only
      # comportement par défaut- perso à prévoir du message d'erreur (vs mail déjà pris)
      User.invite_existing_user!({:email => @user.email}, current_user)

    # si le user n'existe pas
    else
      # comportement classique + rajout au groupe
      super do |u|
        u.groups.push(find_group)
      end
    end
  end

  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?


    # si le user n'existait pas
    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      end

      if self.method(:after_invite_path_for).arity == 1
      respond_with resource, :location => after_invite_path_for(current_inviter)
      else
      respond_with resource, :location => after_invite_path_for(current_inviter, resource)
      end

    # si le user existe mais n'appartenait pas au groupe
    # elsif

    # si le user existe ou a déjà été invité ou intégré au groupe
    else
      redirect_to new_group_invitation_path(find_group)
      if self.resource.sign_in_count.positive?
        flash[:notice] = "#{self.resource.email} a été intégré(e) au groupe #{find_group.name} ."
      else
        # cela veut dire qu'il ne s'est jamais loggué
        flash[:alert] = "#{self.resource.email} a été invité(e) au groupe #{find_group.name} ."
      end
    end
  end
  # rubocop:enable all

  def for_coaches_only
    @user = User.find_by(email: invite_params[:email])
    # si le user existe, qu'il appartienne ou non au groupe et est un coach
    if @user.coach?
      @group.coaches.push(@user.coach)
      # ajout au groupe en tant que coach
      flash[:notice] = "#{@user.full_name} a été ajouté en tant que coach du groupe #{find_group.name} ."
    end
  end

  def after_invite_path_for(_resource)
    group_participants_path(find_group)
  end


  private

  def find_group
    @group = Group.find(params[:user][:group_id])
  end

  def set_user
    @user = User.find_by(email: invite_params[:email])
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation,
                                      keys: [:email, :password, :password_confirmation,
                                             :invitation_token, :user_terms_acceptance])
  end
end
