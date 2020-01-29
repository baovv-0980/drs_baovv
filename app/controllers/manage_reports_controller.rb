class ManageReportsController < ApplicationController

  def show
    @search = ApprovalRequestSearch.new(params[:search])
    @user = User.find_by id: params[:id]
    @reports = @search.scope(@user.reports).paginate(page: params[:page], per_page: Settings.requests.per_page)
    flash.now[:success] = t ".no_report" if @reports.blank?
  end
end
