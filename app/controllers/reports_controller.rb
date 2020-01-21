class ReportsController < ApplicationController
  def index
    @reports = second_user.reports.paginate(page: params[:page],
                                    per_page: Settings.reports.per_page)
  end

  def new
    @report = second_user.reports.build
  end

  def show
    @report = current_user.reports.find_by id: params[:id]
    respond_to do |format|
      format.html
      format.js{flash.now[:notice] = t ".not_found" if @report.blank?}
    end
  end

  def create
    @report = current_user.reports.build report_params
    if @report.save
      flash[:success] = t ".create_fault"
      redirect_to reports_path
    else
      flash.now[:failure] = t ".create_report"
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
      current_division.parent.users.manager.each do |manager|
         report.notifications.create(title: "You has new report", sender_id: second_user.id,receiver_id: manager.id)
      end
    else
      flash[:success] = t "Ban k the tao bai viet"
      redirect_to root
    end
  end
end
