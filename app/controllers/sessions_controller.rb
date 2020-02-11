class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to root_path
    else
      flash.now[:error] = t ".flash_login"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
