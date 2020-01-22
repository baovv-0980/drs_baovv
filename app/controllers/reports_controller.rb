class ReportsController < ApplicationController
  def index
    @reports = second_user.reports.paginate(page: params[:page],
                                    per_page: Settings.reports.per_page)
    redirect_to root_path if @reports.blank?
  end

  def new
    @report = second_user.reports.build
  end

  def show
    if params[:type] == "notifi"
      @report = Report.find_by id: params[:id]
    elsif params[:type] == "report"
      @report = second_user.reports.find_by id: params[:id]
    else
      flash[:success] = "Ban da co y pham loi"
      redirect_to root_path
    end
    render :index if @report.blank?
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @report = second_user.reports.build report_params
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
    if second_user.member?
      current_division.users.manager.each do |manager|
        report.notifications.create(title: "You has new report", sender_id: second_user.id,receiver_id: manager.id)
      end
    elsif second_user.manager?
      if current_division.parent.blank?
        flash[:success] = t "Ban dang o vi tri cao nhat"
        redirect_to root
      else
        current_division.parent.users.manager.each do |manager|
         report.notifications.create(title: "You has new report", sender_id: second_user.id,receiver_id: manager.id)
        end
      end
    else
      flash[:success] = t "Ban k the tao bai viet"
      redirect_to root
    end
  end
end
