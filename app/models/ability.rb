class Ability
  include CanCan::Ability

  def initialize current_user
    current_user ||= User.new
    if current_user.member?
      can :manage, :all, user_id: current_user.id
    elsif current_user.manager?
      can :manage, :all
    else
      cannot :manage, ApprovalRequest
    end
  end
end
