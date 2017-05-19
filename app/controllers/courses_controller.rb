class CoursesController < ApplicationController
  # on a besoin de group pour créer un course
  before_action :find_group, only: [:new, :create]
  # before_action :find_course, only: []

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params(course_params))
    @course.group = @group
    if @course.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def course_params
    params.require(:course).permit(:name, :sport_id, :address, :meeting_point,
                                   :capacity_max,
                                   :details,
                                   :coach_id)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  # def find_course
  #   @course = Course.find(params[:id])
  # end
end
