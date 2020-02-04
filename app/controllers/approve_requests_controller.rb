class ApproveRequestsController < ApplicationController
  before_action :manager_user
  before_action :correct_request, only: [:update, :show]
  before_action :logged_in_user

  def index
    @search = ApprovalRequestSearch.new(params[:search])
    @requests = @search.scope(current_division.approval_requests).paginate(page: params[:page], per_page: Settings.requests.per_page)
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @request.status == Settings.enum.waiting
      ActiveRecord::Base.transaction do
        @request.update!(status: params[:status])
        create_parent_request if params[:status] == Settings.enum.approval
        rejected_request if params[:status] == Settings.enum.rejected
        flash_success
      rescue ActiveRecord::RecordInvalid
        flash_fault
      end
    else
      flash[:success] = t ".load_error"
      redirect_to approve_requests_path
    end
  end

  private

  def rejected_request
    @request.request.notifications.create!(title: t(".reject_title"), sender_id: current_user.id, receiver_id: @request.request.user_id, status: Settings.enum.rejected)
    @request.request.update!(status: Settings.enum.rejected)
  end

  def create_parent_request
    if current_division.parent_id.blank?
      @request.request.update!(status: Settings.enum.approval)
      send_notifi_user @request
    else
      @request = current_division.parent.approval_requests.create!(request_id: @request.request_id)
      send_notifi_manager @request
      forwarded_request_user @request
    end
  end

  def forwarded_request_user _user_request
    @request.request.update!(status: Settings.enum.forwarded)
  end

  def send_notifi_user user_request
    user_request.request.notifications.create!(title: t(".approve_title"), sender_id: current_user.id, receiver_id: user_request.request.user_id, status: Settings.enum.approval)
  end

  def send_notifi_manager user_request
    current_division.parent.users.manager.each do |manager|
      user_request.notifications.create!(title: t(".title"), sender_id: current_user.id, receiver_id: manager.id)
    end
  end

  def manager_user
    redirect_to root_path unless current_user.manager?
  end

  def correct_request
    @request = current_division.approval_requests.find_by id: params[:id]
    return if @request

    flash[:success] = t "approve_requests.not_exits"
    redirect_to root_path
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
