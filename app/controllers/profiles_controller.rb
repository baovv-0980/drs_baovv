class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.paginate(page: params[:page], per_page: Settings.requests.per_page)
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update(user_params)
      flash[:success] = t "Cap nhat thanh cong"
      redirect_to profile_path(@user)
    else
      flash.now[:error] = t ".update_fault"
      render :edit
    end
  end

  def user_params
    params.require(:user).permit User::PARAMS_PROFILE
  end
end
