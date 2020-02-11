module SessionHelper
  def current_division
    @current_division = current_user.division
  end

  def notification
    @notifications = current_user.notifications.all.reverse if current_user.present?
  end
end
