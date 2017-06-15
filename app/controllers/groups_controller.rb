class GroupsController < ApplicationController
  before_action :find_group, only: [:edit, :update, :destroy, :group_participants]

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    authorize @group # check authorization before save

    @group.users.push(current_user) #populate the groups_users table

    if @group.save
      redirect_to new_group_course_path(@group)
    else
      render :new
    end
  end

  def edit
    authorize @group
  end

  def update
    authorize @group # check authorization before update
    if @group.update(group_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def destroy
    authorize @group # check authorization before destroy
    @group.destroy
    redirect_to dashboard_path
  end

  def group_participants
     authorize @group
     @group.users
  end

  private

  def find_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :photo)
  end
end
