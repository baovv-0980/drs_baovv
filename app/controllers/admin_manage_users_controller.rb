class AdminManageUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy, :update]
  before_action :admin_user, except: [:show]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.paginate(page: params[:page], per_page: Settings.users.per_page)
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
    if(params[:user][:birthday].blank? || params[:user][:birthday] > Time.now)
      @user.errors.add(:birthday, "Start time and End time can vailid!")
      flash.now[:error] = "Create a new user errors"
      render :new
    else
      if @user.save
        flash[:info] = t ".create_success"
        redirect_to admin_manage_users_path
      else
        flash.now[:error] = "Create a new user errors"
        render :new
      end
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t ".update"
      redirect_to admin_manage_users_path
    else
      flash.now[:error] = "Update User Error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete"
      redirect_to admin_manage_users_path
    else
      flash[:error] = t ".delete_fail"
      redirect_to root_path
    end
  end

  private

  def admin_user
    return current_user.admin?
    flash[:error] = "You can't Admin"
    redirect_to root_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:error] = t "admin_manage_users.not_exits"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::PARAMS
  end
end
