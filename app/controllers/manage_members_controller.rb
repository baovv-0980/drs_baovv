class ManageMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :manager_user

  def show
    @group = Group.find_by id: params[:id]
    @q = @group.users.ransack(params[:q])
    @users = @q.result.paginate(page: params[:page], per_page: Settings.requests.per_page)
  end

  def destroy
    @user_group = UserGroup.find_by(user_id: params[:user_id], group_id: params[:group_id])
    if @user_group.destroy
      redirect_to manage_member_path(params[:group_id])
    else
      flash[:error] = "Destroy user of group failure"
      redirect_to root_path
    end
  end

  private

  def manager_user
    redirect_to root_path unless current_user.manager?
  end
end
