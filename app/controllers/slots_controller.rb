class SlotsController < ApplicationController
  before_action :find_course, only: [:new, :create]

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(slot_params)
    @slot.course = @course
    if @slot.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  private

  def slot_params
    params.require(:slot).permit(:capacity_min,
                                 :date,
                                 :start_time_hours,
                                 :start_date_minutes
                                 :end_time_hours
                                 :end_time_minutes) # <!-- vérifier le 's' -->
  end

  def find_course
    @course = course.find(params[:course_id])
  end
end
