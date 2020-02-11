class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  skip_authorize_resource

  def index
  end
end
