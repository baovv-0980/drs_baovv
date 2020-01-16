class ReportsController < ApplicationController
  def index
    @reports = current_user.reports.paginate(page: params[:page],
                                    per_page: Settings.reports.per_page)
  end

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      flash[:success] = t ".create_fault"
      redirect_to reports_path
    else
      flash.now[:success] = t ".create_report"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit Report::PARAMS
  end
end
