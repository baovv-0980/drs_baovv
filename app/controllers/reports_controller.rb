class ReportsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

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
    @group_id = params[:report][:group_id]
    ActiveRecord::Base.transaction do
      @report.save!
      send_notification @report, @group_id
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

  def send_notification report, group_id
    @group = Group.find_by(id: group_id)
    @user_groups = @group.user_groups.where(role: "leader")
    @manager_projects =  manager_project @user_groups
    @manager_projects.each do |manager|
      report.notifications.create!(title: t(".notifi_title"), sender_id: current_user.id, receiver_id: manager.id)
    end
  end

  def manager_project user_group
    @manager_projects = []
    user_group.each{|i| @manager_projects.push(i.user) if i.user != current_user}
    @manager_projects
  end
end
