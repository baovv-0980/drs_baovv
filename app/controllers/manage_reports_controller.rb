class ManageReportsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: :manage_reports

  def show
    @q = current_user.reports.ransack(params[:q])
    @reports = @q.result.paginate(page: params[:page], per_page: Settings.reports.per_page)
    if params[:date]
      search = date_choose(params[:date])
      @reports = current_user.reports.where(group_id: params[:id]).range_date(search).paginate(page: params[:page], per_page: Settings.reports.per_page)
    end
  end
end
