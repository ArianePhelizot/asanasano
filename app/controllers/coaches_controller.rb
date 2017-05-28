class CoachesController < ApplicationController


before_action :set_coach

  def edit
  end

  def update
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

  def coach_params
      params.require(:coach).permit(:description)
  end

end
