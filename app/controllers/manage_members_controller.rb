class ManageMembersController < ApplicationController
  before_action :manager_user
  before_action :correct_user, only: [:update]

  def index
    if params[:q].blank?
      @users = current_division.users.paginate(page: params[:page],per_page: Settings.requests.per_page)
    else
      @users = current_division.users.search_user(params[:q]).paginate(page: params[:page],per_page: Settings.requests.per_page)
    end
  end

  def update
    if @user.update(division_id: nil)
      flash[:success] = t ".update"
      redirect_to manage_members_path
    else
      flash[:failure] = t ".update_fault"
      render :index
    end
  end

  private

  def manager_user
    return current_user.manager?
    flash[:empty] = t "manager.not_exits"
    redirect_to root_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:empty] = t "member.not_exits"
    redirect_to root_path
  end
end
