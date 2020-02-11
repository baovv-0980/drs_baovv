class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @group_id = current_user.groups.first&.id
    @reports = current_user.reports.where(group_id: @group_id).paginate(page: params[:page], per_page: Settings.reports.per_page)
    @group_id ||= 1
  end

  def new
    @report = current_user.reports.new
  end

  def show
    if params[:q].blank?
      @reports = current_user.reports.where(group_id: params[:id]).paginate(page: params[:page], per_page: Settings.reports.per_page)

    else
      @reports = current_user.reports.where(group_id: params[:id]).search_reports(params[:q]).paginate(page: params[:page], per_page: Settings.reports.per_page)
    end
    @group_id = params[:id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @report = current_user.reports.new report_params
    ActiveRecord::Base.transaction do
      @report.save!
      # send_notification @report
      flash[:success] = t ".create_success"
      redirect_to reports_path
    rescue ActiveRecord::RecordInvalid
      flash.now[:success] = t ".create_fault"
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
