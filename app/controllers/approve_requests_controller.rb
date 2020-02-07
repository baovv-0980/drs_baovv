class ApproveRequestsController < ApplicationController
  before_action :manager_user
  before_action :correct_request, only: [:update, :show]

  def index
    @approval_requests = current_division.approval_requests.paginate(page: params[:page],
                                    per_page: Settings.requests.per_page)
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @approval_request.update! status: params[:status]
      create_parent_request if params[:status] == Settings.enum.approval
      rejected_request if params[:status] == Settings.enum.rejected
      flash[:success] = t ".update"
      redirect_to approve_requests_path
    rescue ActiveRecord::RecordInvalid
      flash[:failure] = t ".update_fault"
      render :index
    end
  end

  private

  def rejected_request
    @approval_request.request.update! status: Settings.enum.rejected
  end

  def create_parent_request
    if current_division.parent_id.blank?
      @approval_request.request.update! status: Settings.enum.approval
    else
      @approval_request.request.update! status: Settings.enum.forwarded
      current_division.parent.approval_requests.create!(request_id: @approval_request.request_id)
    end
  end

  def manager_user
    redirect_to root_path unless current_user.manager?
  end

  def correct_request
    @approval_request = current_division.approval_requests.find_by id: params[:id]
    return if @approval_request

    flash[:empty] = t "approve_requests.not_exits"
    redirect_to root_path
  end
end
