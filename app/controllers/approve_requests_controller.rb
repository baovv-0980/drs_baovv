class ApproveRequestsController < ApplicationController
  before_action :manager_user
  before_action :correct_request, only: [:update, :show]

  def index
    @search = ApprovalRequestSearch.new(params[:search])
    @requests = @search.scope(current_division.approval_requests).paginate(page: params[:page], per_page: Settings.requests.per_page)
    flash.now[:success] = t ".no_found" if @requests.blank?
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @request.update(status: params[:status])
      create_parent_request if params[:status] == Settings.enum.approval
      rejected_request if params[:status] == Settings.enum.rejected
    else
      flash_success
    end
  end

  private

  def rejected_request
    ActiveRecord::Base.transaction do
      @request.request.notifications.create!(title: t(".reject_title") , sender_id: current_user.id, receiver_id: @request.request.user_id, status: Settings.enum.rejected)
      @request.request.update!(status: Settings.enum.rejected)
      flash_success
    rescue StandardError
      flash_fault
    end
  end

  def create_parent_request
    if current_division.parent_id.blank?
      ActiveRecord::Base.transaction do
        @request.request.update!(status: Settings.enum.approval)
        send_notifi_user @request
        flash_success
      rescue StandardError
        flash_fault
      end
    else
      ActiveRecord::Base.transaction do
        current_division.parent.approval_requests.create!(request_id: @request.request_id)
        send_notifi_manager @request
        send_notifi_user @request
        flash_success
      rescue StandardError
        flash_fault
      end
    end
  end

  def send_notifi_user user_request
    user_request.request.notifications.create!(title: t(".approve_title"), sender_id: current_user.id, receiver_id: user_request.request.user_id, status: Settings.enum.approval)
  end

  def send_notifi_manager user_request
    current_division.parent.users.manager.each do |manager|
      user_request.request.notifications.create(title: t(".title"), sender_id: current_user.id,receiver_id: manager.id)
    end
  end

  def manager_user
    redirect_to root_path unless current_user.manager?
  end

  def correct_request
    @request = current_division.approval_requests.find_by id: params[:id]
    # flash[:success] = t "approve_requests.not_exits"
    redirect_to root_path if @request.blank?
  end

  def flash_success
    flash[:success] = t ".update_success"
    redirect_to approve_requests_path
  end

  def flash_fault
    flash[:success] = t ".update_fault"
    redirect_to errors_path
  end
end
