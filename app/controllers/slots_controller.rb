class SlotsController < ApplicationController
  before_action :find_course, only: [:new, :create, :edit, :update]
  before_action :find_slot, only: [:edit, :update]
  def new
    @slot = Slot.new
    authorize @slot
  end

  def create
    @slot = Slot.new(slot_params)
    @slot.course = @course
    authorize @slot # check authorization before save
    if @slot.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def edit
    authorize @slot # check authorization before edit
  end

  def update
    authorize @slot # check authorization before update
    if @slot.update(slot_params)
      redirect_to course_path(@course)
    else
      render :edit
    end
  end

  private

  def slot_params
    params.require(:slot).permit(:participants_min,
                                 :date,
                                 :start_at,
                                 :end_at
                                 :
                                 :end_time_minutes) # <!-- vérifier le 's' -->
  end

  def find_course
    @course = course.find(params[:course_id])
  end

  def find_slot
    @slot = Slot.find(params[:id])
  end
end
