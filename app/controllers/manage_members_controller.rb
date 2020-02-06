class ManageMembersController < ApplicationController
  before_action :manager_user
  before_action :correct_user, only: [:update]
  before_action :logged_in_user

  def index
    @users = current_division.users.search(params[:t], params[:q]).paginate(page: params[:page], per_page: Settings.requests.per_page)
  end

  def update
    if @user.update(division_id: nil)
      flash[:success] = t ".update"
      redirect_to manage_members_path
    else
      flash[:success] = t ".update_fault"
      render :index
    end
  end

  private

  def manager_user
    redirect_to root_path unless current_user.Manager?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:success] = t "member.not_exits"
    redirect_to root_path
  end
end
