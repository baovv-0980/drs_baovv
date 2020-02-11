class ManageGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_group, only: [:destroy, :update]
  before_action :manager_user

  def index
    @q = Group.ransack(params[:q])
    @groups = @q.result.paginate(page: params[:page], per_page: Settings.requests.per_page)
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find_by id: params[:id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @group = Group.find_by id: params[:id]
  end

  def create
    @group = Group.new group_params
    if @group.save
      flash[:success] = t ".create_success"
      redirect_to manage_groups_path
    else
      flash[:error] = t ".create_success"
      render :new
    end
  end

  def update
    if @group.update(group_params)
      flash[:success] = "Update Group Success"
      redirect_to manage_groups_path
    else
      flash[:error] = t "Update Group Failure"
      redirect_to root_path
    end
  end

  def destroy
    if @group.destroy
      flash[:success] = "Destroy Group Success"
      redirect_to manage_groups_path
    else
      flash[:error] = "Destroy Group Success"
      redirect_to root_path
    end
  end

  private

  def manager_user
    return if current_user.manager?

    flash[:error] = "You can't Manager"
    redirect_to root_path
  end

  def correct_group
    @group = Group.find_by id: params[:id]
    return if @group

    flash[:error] = t "admin_manage_users.not_exits"
    redirect_to root_path
  end

  def group_params
    params.require(:group).permit Group::PARAMS
  end
end
