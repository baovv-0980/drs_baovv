module SessionHelper
  def current_division
    @current_division = current_user.division
  end
  def manage_report
    current_user.user_groups.where(role: "leader")
  end
end
