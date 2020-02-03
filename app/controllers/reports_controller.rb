class ReportsController < ApplicationController
  def index
    @reports = current_user.reports.paginate(page: params[:page],
                                    per_page: Settings.reports.per_page)
    flash.now[:success] = t ".list_empty" if @reports.blank?
  end

  def new
    @report = current_user.reports.build
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
      flash.now[:success] = t ".create_report"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit Report::PARAMS
  end
end
