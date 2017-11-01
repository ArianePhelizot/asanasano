# frozen_string_literal: true

class CoachesController < ApplicationController
  before_action :set_coach, except: [:new, :create]
  before_action :set_user, only: [:create]

  def new
    @coach = Coach.new
    authorize @coach
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def create
    @coach = Coach.new(coach_params)
    @coach.params_set = ParamsSet.first
    authorize @coach

    if @coach.save
      @user.coach_id = @coach.id
      @user.agreed_to_terms = true
      @user.save
      @user.send_welcome_pro_email
      if @user.account
        redirect_to edit_user_account_path(@user, @user.account.id)
      else
        redirect_to new_user_account_path(current_user)
      end
    else
      render :new
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def edit; end

  def update
    sports = sports_update
    sports_instances = Sport.where(id: sports)
    @coach.sports = sports_instances
    @coach.languages = languages_update
    if @coach.update(coach_params)
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def set_coach
    @coach = Coach.find(params[:id])
    authorize @coach
  end

  def set_user
    @user = current_user
  end

  def coach_params
    params.require(:coach).permit(:description, :sport_ids, :experience,
                                  :languages, :training, :website, :facebook,
                                  :twitter, :instagram, :linkedin,
                                  :pinterest, :youtube,
                                  :price, :locations,
                                  :comments, :availabilities)
  end

  def sports_update
    sports = params["coach"]["sport_ids"]
    sports.delete_at(0)
    sports.map(&:to_i)
  end

  def languages_update
    languages = params["coach"]["languages"]
    languages.delete_at(0)
    languages
  end
end
