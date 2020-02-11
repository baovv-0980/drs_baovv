class AddMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :manager_user

  def index
    if params[:q].blank?
      @users = User.all.paginate(page: params[:page], per_page: Settings.users.per_page)
    else
      @users = User.search_user(params[:q]).paginate(page: params[:page], per_page: Settings.users.per_page)
    end
  end

  def show
    @user = User.find_by id: params[:id]
    @user_group = UserGroup.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
     @user_group = UserGroup.new user_group_params
    if @user_group.save
      flash[:success] = "Add Member to Group Success"
      redirect_to add_members_path
    else
      flash[:failure] = "Add Member to Group Failure"
      redirect_to errors_path
    end
  end

  private

  def manager_user
    redirect_to root_path unless current_user.manager?
  end

  def user_group_params
    params.require(:user_group).permit UserGroup::PARAMS
  end
end
