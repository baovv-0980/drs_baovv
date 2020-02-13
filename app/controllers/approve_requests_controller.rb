class ApproveRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_request, only: [:update, :show]

  authorize_resource class: :approve_requests

  def index
    @q = current_division.approval_requests.ransack(params[:q])
    @approval_requests = @q.result.paginate(page: params[:page],per_page: Settings.requests.per_page)
    if params[:date]
      search = date_choose(params[:date])
      @approval_requests = current_division.approval_requests.range_date(search).paginate(page: params[:page], per_page: Settings.requests.per_page)
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @approval_request.status == Settings.enum.waiting
      ActiveRecord::Base.transaction do
        @approval_request.update!(status: params[:status])
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
    @approval_request.request.notifications.create!(title: t(".reject_title"), sender_id: current_user.id, receiver_id: @approval_request.request.user_id, status: Settings.enum.rejected)
    @approval_request.request.update!(status: Settings.enum.rejected)
  end

  def create_parent_request
    if current_division.parent_id.blank?
      @approval_request.request.update!(status: Settings.enum.approval)
      send_notifi_user @approval_request
    else
      @approval_request = current_division.parent.approval_requests.create!(request_id: @approval_request.request_id)
      send_notifi_manager @approval_request
      forwarded_request_user @approval_request
    end
  end

  def forwarded_request_user _user_request
    @approval_request.request.update!(status: Settings.enum.forwarded)
  end

  def send_notifi_user user_request
    user_request.request.notifications.create!(title: t(".approve_title"), sender_id: current_user.id, receiver_id: user_request.request.user_id, status: Settings.enum.approval)
  end

  def send_notifi_manager user_request
    current_division.parent.users.manager.each do |manager|
      user_request.notifications.create!(title: t(".title"), sender_id: current_user.id, receiver_id: manager.id)
    end
  end

  def correct_request
    @approval_request = current_division.approval_requests.find_by id: params[:id]
    return if @approval_request

    flash[:success] = t "approve_requests.not_exits"
    redirect_to root_path
  end

  def flash_success
    flash[:success] = t ".update_success"
    redirect_to approve_requests_path
  end

  def flash_fault
    flash[:error] = t ".update_fault"
    redirect_to errors_path
  end
end
