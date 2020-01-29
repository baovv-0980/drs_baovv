class ReportsController < ApplicationController
  def index
    @reports = current_user.reports.paginate(page: params[:page],
                                    per_page: Settings.reports.per_page)
    redirect_to root_path if @reports.blank?
  end

  def new
    @report = current_user.reports.build
  end

  def show
    if params[:type] == Settings.notifi
      @report = Report.find_by id: params[:id]
    elsif params[:type] == Settings.reports.report
      @report = current_user.reports.find_by id: params[:id]
    elsif params[:type] == Settings.reports.user_report
      @user = User.find_by id: params[:user_id]
      @report = @user.reports.find_by id: params[:id]
    else
      flash[:success] = t ".error"
      redirect_to errors_path
    end
    flash.now[:success] = t ".not_found"
    render :index if @report.blank?
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @report = current_user.reports.build report_params
    if @report.save
      send_notification @report
      flash[:success] = t ".create_success"
      redirect_to reports_path
    else
      flash.now[:success] = t ".create_fault"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit Report::PARAMS
  end

  def send_notification report
    if current_user.member?
      current_division.users.manager.each do |manager|
        report.notifications.create(title: t(".notifi_title"), sender_id: current_user.id,receiver_id: manager.id)
      end
    elsif current_user.manager?
      if current_division.parent.blank?
        flash[:success] = t ".highest_division"
        redirect_to reports_path
      else
        current_division.parent.users.manager.each do |manager|
         report.notifications.create(title: t(".notifi_title"), sender_id: current_user.id,receiver_id: manager.id)
        end
      end
    else
      flash[:success] = t ".create_fault"
      redirect_to errors_path
    end
  end
end
