class CoachesController < ApplicationController


before_action :set_coach

  def edit
  end

  def update
    binding.pry
    if @coach.update(coach_params)
      @coach.sports = sports_update
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
      params.require(:coach).permit(:description, :sport_ids)
  end

  def sports_update
    params["sport_ids"].delete_at[0].map {|id| id.to_i}
  end

end
