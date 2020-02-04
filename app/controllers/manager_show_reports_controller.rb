class ManagerShowReportsController < ApplicationController
  before_action :logged_in_user

  def index
    @reports = current_division.reports.joins(:user).search(params[:q]).paginate(page: params[:page],per_page: Settings.requests.per_page)
  end
end
