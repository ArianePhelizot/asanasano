# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  # def invite_resource
  #   # group tracking
  #   super do |u|
  #     u.groups.push(find_group)
  #   end
  # end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def invite_resource(&block)
    # je regarde si je connais l'adresse email
    @user = User.find_by(email: invite_params[:email])

    # si le user existe et n'appartient pas déjà au groupe
    if @user && !@user.groups.include?(find_group)
      @user.groups.push(find_group)
      # invite! instance method returns a Mail::Message instance
      @user.invite!(current_user)
      # return the user instance to match expected return type
      @user

    # si le user existe et appartient déjà au groupe
    elsif @user && @user.groups.include?(find_group)
      # comportement par défaut- perso à prévoir du message d'erreur (vs mail déjà pris)
      super

    # si le user n'existe pas
    else
      # comportement classique + rajout au groupe
      super do |u|
        u.groups.push(find_group)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def after_invite_path_for(resource)
    group_participants_path(find_group)
  end

  private

  def find_group
    @group = Group.find(params[:user][:group_id])
  end
end
