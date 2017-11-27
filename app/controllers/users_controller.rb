# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i(profile edit update)

  def profile; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
    authorize @user
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :phone_number,
                                 :photo,
                                 :photo_cache,
                                 :user_terms_acceptance)
  end
end
