class RequestsController < ApplicationController
  before_action :logged_in_user

  def index
    @requests = current_user.requests.paginate(page: params[:page],
                                    per_page: Settings.requests.per_page)
  end

  def show
    if params[:type] == "notifi"
      @request = Request.find_by id: params[:id]
    elsif params[:type] == "request"
      @request = current_user.requests.find_by(id: params[:id])
    else
      flash[:success] = t ".error"
      redirect_to errors_path
    end
    flash.now[:success] = t ".not_found"
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
      flash.now[:success] = t ".create_fault"
      render :new
    end
  end

  def destroy
    @request = current_user.requests.find_by id: params[:id]
    if @request.status == Settings.enum.waiting
      if @request.destroy
        flash[:success] = t ".post_destroy"
        redirect_to requests_path
      else
        flash[:success] = t ".destroy_fault"
        redirect_to errors_path
      end
    else
      flash[:success] = t ".load_error"
      redirect_to requests_path
    end
  end

  private

  def request_params
    params.require(:request).permit Request::PARAMS
  end

  def save_approval_request division
    ActiveRecord::Base.transaction do
      @request.save!
      @approval_request = @request.approval_requests.create! division_id: division.id
      division.users.manager.each do |manager|
        @approval_request.notifications.create!(title: t(".title"), sender_id: current_user.id, receiver_id: manager.id)
      end
      flash[:success] = t ".create_request"
      redirect_to requests_path
    rescue ActiveRecord::RecordInvalid
      flash.now[:success] = t ".create_fault"
      render :new
    end
  end
end
