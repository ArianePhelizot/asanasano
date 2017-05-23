class CoursesController < ApplicationController
  # on a besoin de group pour créer un course
  before_action :find_group, only: [:new, :create, :edit, :update]
  before_action :find_course, only: [:show, :edit, :update, :destroy]

  def show
    @group = @course.group
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
    #... en fonction de si le current_user est le owner du group ou le coach du cours
    authorize @group
    @user = current_user
  end

  def update
    authorize @course # check authorization before update
    if @course.update(course_params)
      redirect_to course_path(@course)
    else
      render :edit
    end
  end

  def destroy
    authorize @course # check authorization before destroy
    group = @course.group
    @course.destroy
    redirect_to group_path(group)
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
                                   :content)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_course
    @course = Course.find(params[:id])
  end
end
