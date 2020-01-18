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
      if current_user.division.parent_id.nil?
        flash.now[:success] = t ".highest_division"
        render :new
      else
        save_approval_request current_division.parent_id
      end
    elsif current_user.member?
      save_approval_request current_division.id
    end
  end

  def destroy
    if @request.destroy
      flash[:success] = t ".post_destroy"
      redirect_to request.referer || root_path
    else
      flash.now[:success] = t ".destroy_fault"
      render :index
    end
  end

  private

  def request_params
    params.require(:request).permit Request::PARAMS
  end

  def correct_request
    @request = current_user.requests.find_by id: params[:id]
    flash[:success] = t ".destroy_fault"
    redirect_to root_path if @request.nil?
  end

  def save_approval_request division_id
    Request.transaction do
      @request.save
      @request.approval_requests.create! division_id: division_id
      flash[:success] = t ".create_request"
      redirect_to requests_path
    rescue StandardError
      flash.now[:success] = t ".create_fault"
      render :new
    end
  end
end
