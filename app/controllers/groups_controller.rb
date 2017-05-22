class GroupsController < ApplicationController
  before_action :find_group, only: [:edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    authorize @group # check authorization before save
    if @group.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
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

  private

  def find_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :photo)
  end
end
