class AdminManageUsersController < ApplicationController
  before_action :correct_user, only: [:destroy, :update, :edit]
  before_action :admin_user

  def index
    @users = User.search_user(params[:q]).paginate(page: params[:page],per_page: Settings.requests.per_page)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".create_success"
      redirect_to admin_manage_users_path
    else
      flash.now[:failure] = t ".create_fault"
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t ".update"
      redirect_to admin_manage_users_path
    else
      flash.now[:failure] = t ".update_fault"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:success] = t ".delete_fault"
    end
    redirect_to admin_manage_users_path
  end

  private

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:empty] = t "user.not_exits"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::PARAMS
  end
end
