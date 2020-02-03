class ProfilesController < ApplicationController
  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update(user_params)
      flash[:success] = t ".update_success"
      redirect_to root_path
    else
      flash.now[:success] = t ".update_fault"
      render :edit
    end
  end

  def user_params
    params.require(:user).permit User::PARAMS_PROFILE
  end
end
