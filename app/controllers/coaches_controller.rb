class CoachesController < ApplicationController


before_action :set_coach

  def edit
  end

  def update
    # binding.pry
    sports = sports_update
    sports_instances = Sport.where(:id => sports)
    @coach.sports = sports_instances
    # binding.pry
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
      params.require(:coach).permit(:description, :sport_ids)
  end

  def sports_update
    sports = params["coach"]["sport_ids"]
    sports.delete_at(0)
    sports.map {|id| id.to_i}
  end

end
