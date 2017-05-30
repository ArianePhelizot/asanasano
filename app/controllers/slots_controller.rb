class SlotsController < ApplicationController
  before_action :find_course, only: [:new, :create, :edit, :update]
  before_action :find_slot, only: [:edit, :update, :desinscription]

  def new
    # récupérer les infos de la dernière séance créée
    # créer la nouvelle slot avec ces attributs
    @slot = Slot.new
    @slot.course = @course
    authorize @slot
  end

  def create
    @slot = Slot.new(slot_params)
    @slot.course = @course
    @group = @course.group
    authorize @slot # check authorization before save
    if @slot.save
      respond_to do |format|
        format.html { redirect_to course_path(@course) }
        format.js  # <-- will render `app/views/slots/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'courses/show' }
        format.js  # <-- idem
      end
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

  def desinscription
    authorize @slot
    @slot.users.delete(current_user)
    @course = @slot.course
    respond_to do |format|
      format.html { redirect_to course_path(@course) }
      format.js  # <-- will render `app/views/slots/desinscription.js.erb`
    end
  end

  private

  def slot_params
    params.require(:slot).permit(:participants_min,
                                 :date,
                                 :start_at,
                                 :end_at,
                                 :price)
  end

  def find_course
    @course = Course.find(params[:course_id])
  end

  def find_slot
    @slot = Slot.find(params[:id])
  end
end
