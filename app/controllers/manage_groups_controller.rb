class ManageGroupsController < ApplicationController
  before_action :correct_group, only: [:destroy, :update]
  before_action :manager_user
  before_action :logged_in_user

  def index
    if params[:q].blank?
      @groups = Group.all.paginate(page: params[:page], per_page: Settings.requests.per_page)
    else
      @groups = Group.search_group(params[:q]).paginate(page: params[:page], per_page: Settings.requests.per_page)
    end
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
      flash[:info] = t ".create_success"
      redirect_to manage_groups_path
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      flash[:success] = "Update Group Success"
      redirect_to manage_groups_path
    else
      flash[:failure] = t "Update Group Failure"
      redirect_to root_path
    end
  end

  def destroy
    if @group.destroy
      flash[:success] = "Destroy Group Success"
      redirect_to manage_groups_path
    else
      flash[:failure] = "Destroy Group Success"
      redirect_to root_path
    end
  end

  private

  def manager_user
    redirect_to root_path unless current_user.manager?
  end

  def correct_group
    @group = Group.find_by id: params[:id]
    return if @group
    flash[:empty] = t "admin_manage_users.not_exits"
    redirect_to root_path
  end

  def group_params
    params.require(:group).permit Group::PARAMS
  end
end
