class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = current_user.groups
    @q = current_user.reports.ransack(params[:q])
    @reports = @q.result.paginate(page: params[:page], per_page: Settings.reports.per_page)
  end

  def new
    @report = current_user.reports.new
  end

  def create
    @report = current_user.reports.new report_params
    ActiveRecord::Base.transaction do
      @report.save!
      # send_notification @report
      flash[:success] = t ".create_success"
      redirect_to reports_path
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = t ".create_fault"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit Report::PARAMS
  end

  def send_notification report
    current_division.users.manager.each do |manager|
      report.notifications.create!(title: t(".notifi_title"), sender_id: current_user.id, receiver_id: manager.id)
    end
  end
end
