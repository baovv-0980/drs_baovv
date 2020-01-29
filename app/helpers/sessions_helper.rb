module SessionsHelper
  def current_user
    @current_user = User.find(3)
  end

  def current_division
    @current_division = current_user.division
  end
end
