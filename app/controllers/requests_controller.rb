class RequestsController < ApplicationController
  before_action :correct_request, only: :destroy

  def index
    @requests = current_user.requests.paginate(page: params[:page],
                                    per_page: Settings.requests.per_page)
  end

  def show
    @request = current_user.requests.find_by id: params[:id]
    flash.now[:success] = t ".create_fault"
    render :index if @request.blank?
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @request = current_user.requests.build
  end

  def create
    @request = current_user.requests.build request_params
    if current_user.manager?
      if current_division.parent_id.blank?
        flash.now[:success] = t ".highest_division"
        render :new
      else
        save_approval_request current_division.parent
      end
    elsif current_user.member?
      save_approval_request current_division
    else
      flash[:success] = t "Ban k the tao bai viet"
      redirect_to errors_path
    end
  end

  def destroy
    if @request.destroy
      flash[:success] = t ".post_destroy"
      redirect_to requests_path
    else
      flash[:success] = t ".destroy_fault"
      redirect_to errors_path
    end
  end

  private

  def request_params
    params.require(:request).permit Request::PARAMS
  end

  def correct_request
    @request = current_user.requests.find_by id: params[:id]
    flash[:success] = t ".destroy_fault"
    redirect_to root_path if @request.blank?
  end

  def save_approval_request division
    Request.transaction do
      @request.save
      @request.approval_requests.create! division_id: division.id
      division.users.manager.each do |manager|
        @request.notifications.create(title: "You has new request", sender_id: current_user.id,receiver_id: manager.id)
      end
      flash[:success] = t ".create_request"
      redirect_to requests_path
    rescue StandardError
      flash.now[:success] = t ".create_fault"
      redirect_to errors_path
    end
  end
end
