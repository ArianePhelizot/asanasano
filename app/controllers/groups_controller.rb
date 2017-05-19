class GroupsController < ApplicationController
  before_action :find_group, only: [:edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def create
    authorize @group
    @group = Group.new(params(group_params))
    @group.user = current_user
    if @group.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(params(group_params))
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def destroy
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
