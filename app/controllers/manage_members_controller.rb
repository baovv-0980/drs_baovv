class ManageMembersController < ApplicationController
  before_action :authenticate_user!

  authorize_resource class: :manage_members
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
end
