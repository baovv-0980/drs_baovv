class ManageProjectsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: :manage_projects

  def index
    @user_group = current_user.user_groups.where(role: "leader")
    @groups = load_group @user_group
  end

  def show
  end

  private

  def load_group user_group
    @load_groups = []
    user_group.each{|i| @load_groups.push(i.group)}
    @load_groups.flatten
  end
end
