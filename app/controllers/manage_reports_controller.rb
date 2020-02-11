class ManageReportsController < ApplicationController
  before_action :authenticate_user!

  def show
    if params[:date]
      search = date_choose(params[:date])
      @reports = current_user.reports.where(group_id: params[:id]).range_date(search).paginate(page: params[:page], per_page: Settings.reports.per_page)
    else
      if params[:q].blank?
        @reports = current_user.reports.where(group_id: params[:id]).paginate(page: params[:page], per_page: Settings.reports.per_page)

      else
        @reports = current_user.reports.where(group_id: params[:id]).search_reports(params[:q]).paginate(page: params[:page], per_page: Settings.reports.per_page)
      end
    end
  end
end
