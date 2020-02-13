class GroupsController < ApplicationController
   authorize_resource

  def show
    @group = Group.find_by id: params[:id]
    @q = current_user.reports.where(group_id: @group).ransack(params[:q])
    @reports = @q.result.paginate(page: params[:page], per_page: Settings.reports.per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
