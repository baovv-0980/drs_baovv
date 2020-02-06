class ResetPasswordsController < ApplicationController
  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif params[:user][:password] != params[:user][:password_confirmation]
      @user.errors.add(:password, "false confirmation")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to profile_path(@user)
    else
      flash[:failure] = "Password reset failed."
      render :edit
    end
  end
  def user_params
    params.require(:user).permit User::PARAMS_PASSWORD
  end

end
