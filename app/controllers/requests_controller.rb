class RequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:type].blank? && params[:q].blank?
      @requests = current_user.requests.paginate(page: params[:page],
                                    per_page: Settings.requests.per_page)
    elsif params[:type] && params[:q].blank?
      @requests = current_user.requests.search_type(params[:type]).paginate(page: params[:page],per_page: Settings.requests.per_page)
    elsif params[:type].blank? && params[:q]
      @requests = current_user.requests.joins(:user).search_request(params[:q]).paginate(page: params[:page],per_page: Settings.requests.per_page)
    else
      @requests = current_user.requests.search_type(params[:type]).joins(:user).search_request(params[:q]).paginate(page: params[:page],per_page: Settings.requests.per_page)
    end
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
    @request = current_user.requests.new
  end

  def create
    @request = current_user.requests.new request_params
    if params[:request][:time_from] > params[:request][:time_to] ||  params[:request][:time_to] > Time.now
      @request.errors.add(:time_from, "Start time and End time can vailid!")
      render :new
    else
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
        flash.now[:failure] = t ".create_fault"
        render :new
      end
    end
  end

  def edit
    @request = current_user.requests.find_by id: params[:id]
  end

  def update
     @request = current_user.requests.find_by id: params[:id]
     if @request.update(request_params)
        flash[:success] = "Update sucsses"
        redirect_to requests_path
     else
        flash.now[:failure] = "Update failure"
        render :edit
     end
  end

  def destroy
    @request = current_user.requests.find_by id: params[:id]
    if @request.status == Settings.enum.waiting
      if @request.destroy
        flash[:success] = t ".post_destroy"
        redirect_to requests_path
      else
        flash[:failure] = t ".destroy_fault"
        redirect_to errors_path
      end
    else
      flash[:error] = t ".load_error"
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
      flash.now[:failure] = t ".create_fault"
      render :new
    end
  end
end
