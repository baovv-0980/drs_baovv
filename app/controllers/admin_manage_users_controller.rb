class AdminManageUsersController < ApplicationController
  before_action :correct_user, only: [:destroy, :update]
  before_action :admin_user
  before_action :logged_in_user

  def index
    @users = User.all_user(params[:t], params[:q]).paginate(page: params[:page], per_page: Settings.requests.per_page)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t ".create_success"
      redirect_to admin_manage_users_path
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t ".update"
      redirect_to admin_manage_users_path
    else
      flash[:success] = t ".update_fault"
      redirect_to request.referer || root_path
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete"
      redirect_to request.referer || root_path
    else
      flash[:success] = t ".delete_fail"
      redirect_to admin_manage_users_path
    end
  end

  private

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:success] = t "admin_manage_users.not_exits"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::PARAMS
  end
end
