class AdminManageUsersController < ApplicationController
  before_action :correct_user, only: [:destroy, :update]
  before_action :admin_user, except: [:show]
  before_action :logged_in_user

  def index
    if params[:q].blank?
      @users = User.all.paginate(page: params[:page], per_page: Settings.users.per_page)
    else
      @users = User.search_user(params[:q]).paginate(page: params[:page], per_page: Settings.users.per_page)
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    respond_to do |format|
      format.html
      format.js
    end
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
      flash.now[:errors] = "Create a new user errors"
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t ".update"
      redirect_to admin_manage_users_path
    else
      flash.now[:failure] = t ".update_fault"
      redirect_to :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete"
      redirect_to admin_manage_users_path
    else
      flash[:failure] = t ".delete_fail"
      redirect_to root_path
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
