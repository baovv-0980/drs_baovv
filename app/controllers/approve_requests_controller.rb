class ApproveRequestsController < ApplicationController
  before_action :manager_user
  before_action :correct_request, only: [:update,:show]

  def index
    @requests = current_division.approval_requests.paginate(page: params[:page],
                                    per_page: Settings.requests.per_page)
    redirect_to root_path if @requests.blank?
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if @request.update!(status: params[:status])
      create_parent_request if params[:status] == Settings.enum.approval
      rejected_request if params[:status] == Settings.enum.rejected
      flash[:success] = t ".update"
      redirect_to request.referer || root_path
    else
      flash[:success] = t ".update_fault"
      render :index
    end
  end

  private

  def rejected_request
    @request.request.update!(status: Settings.enum.rejected)
  end

  def create_parent_request
    if current_division.parent_id.blank?
      @request.request.update!(status: Settings.enum.approval)
    else
      current_division.parent.approval_requests.create!(request_id: @request.request_id)
    end
  end

  def manager_user
    redirect_to root_path unless current_user.manager?
  end

  def correct_request
    @request = current_division.approval_requests.find_by id: params[:id]
    flash[:success] = t "approve_requests.not_exits"
    redirect_to root_path if @request.nil?
  end
end
