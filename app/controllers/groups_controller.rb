class GroupsController < ApplicationController
  before_action :find_group, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def create
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
  end

  private

  def find_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :photo)
  end
end
