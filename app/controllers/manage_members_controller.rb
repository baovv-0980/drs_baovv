class ManageMembersController < ApplicationController
  before_action :manager_user
  before_action :correct_user, only: [:update]

  def index
    @users = current_division.users.search(params[:t],params[:q]).paginate(page: params[:page],per_page: Settings.requests.per_page)
    flash.now[:success] = t ".no_find" if @users.blank?
  end

  def update
    if @user.update!(division_id: nil)
      flash[:success] = t ".update"
      redirect_to request.referer || root_path
    else
      flash[:success] = t ".update_fault"
      render :index
    end
  end

  private

  def manager_user
    redirect_to root_path unless current_user.manager?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    flash[:success] = t "member.not_exits"
    redirect_to root_path if @user.blank?
  end
end
