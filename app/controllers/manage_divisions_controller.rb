class ManageDivisionsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_division, only: [:destroy, :update]
  before_action :admin_user

  def index
    if params[:q].blank?
      @divisions = Division.all.paginate(page: params[:page], per_page: Settings.requests.per_page)
    else
      @divisions = Division.search_division(params[:q]).paginate(page: params[:page], per_page: Settings.requests.per_page)
    end
  end

  def show
    if params[:q].blank?
      @users = Division.find_by(id: params[:id]).users.paginate(page: params[:page], per_page: Settings.users.per_page)
    else
      @users = Division.find_by(id: params[:id]).users.search_user(params[:q]).paginate(page: params[:page], per_page: Settings.users.per_page)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @division = Division.new
  end

  def edit
    @division = Division.find_by id: params[:id]
  end

  def create
    @division = Division.new division_params
    if @division.save
      flash[:info] = t ".create_success"
      redirect_to manage_divisions_path
    else
      render :new
    end
  end

  def update
    if @division.update(division_params)
      flash[:success] = t ".update_success"
      redirect_to manage_divisions_path
    else
      flash[:success] = t ".update_fault"
      redirect_to manage_divisions_path
    end
  end

  def destroy
    if @division.destroy
      flash[:success] = t ".destroy_success"
      redirect_to request.referer || root_path
    else
      flash[:success] = t ".destroy_fault"
      redirect_to manage_divisions_path
    end
  end

  private

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_division
    @division = Division.find_by id: params[:id]
    return if @division
    flash[:success] = t "admin_manage_users.not_exits"
    redirect_to root_path
  end

  def division_params
    params.require(:division).permit Division::PARAMS
  end
end
