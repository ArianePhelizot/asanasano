# frozen_string_literal: true

class CoursesController < ApplicationController
  # on a besoin de group pour créer un course
  before_action :find_group, only: %i(new create edit update)
  before_action :find_course, only: %i(show edit update destroy publish depublish)

  def show
    @group = @course.group
    @user = current_user
    @slot = Slot.new
  end

  def new
    @course = Course.new
    # à ce stade le course n'a pas encore de group
    # l'appel de la méthode record.group ne peut donc pas fonctionner dans course_policy.rb.
    # on donne donc son group au course pour pouvoir faire 'authorize @course'
    @course.group = @group
    authorize @course
  end

  def create
    @course = Course.new(course_params)
    @course.group = @group
    authorize @course # check authorization before save
    if @course.save
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def edit
    # On donne ici le current_user à la vue de #edit pour afficher le bon formulaire...
    # ... en fonction de si le current_user est le owner du group ou le coach du cours
    @user = current_user
  end

  def update
    if @course.update(course_params)
      redirect_to course_path(@course)
    else
      render :edit
    end
  end

  def publish
    if @course.publishable?
      @course.active!
      # TODO: envoyer les emails
      flash[:notice] = "Le cours a été publié et les emails envoyés."
    end
    redirect_to dashboard_path
  end

  def depublish
    if @course.depublishable?
      @course.draft!
      flash[:notice] = "Le cours a été désactivé et n'est plus visible des membres du groupe."
    end
    redirect_to dashboard_path
  end

  def destroy
    @course.group
    @course.destroy
    redirect_to dashboard_path
  end

  private

  def course_params
    params.require(:course).permit(:name,
                                   :sport_id,
                                   :address,
                                   :meeting_point,
                                   :capacity_max,
                                   :details,
                                   :coach_id,
                                   :content,
                                   :status)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_course
    @course = Course.find(params[:id])
    authorize @course
  end
end
