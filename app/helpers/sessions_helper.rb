module SessionsHelper
  def current_user
    @current_user = User.first
  end
  def second_user
    @current_user = User.second
  end

  def current_division
    @current_division = current_user.division
  end
end
