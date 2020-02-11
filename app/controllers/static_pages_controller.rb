class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  skip_authorize_resource

  def index
    @division = []
    dq(current_division)
  end

  def dq(division)
    if division.childrens.blank?
      @division.push(division)
    else
      division.childrens.each do |i|
        dq(i)
      end
    end
  end
end
