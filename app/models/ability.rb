class Ability
  include CanCan::Ability

  def initialize current_user
    current_user ||= User.new
    if current_user.member?
      load_member current_user
      if current_user.user_groups.where(role: "leader")
        load_leader current_user
      end
    elsif current_user.manager?
      load_manager current_user
    elsif current_user.admin?
      load_admin current_user
    end
  end

  def load_admin user
    can :manage, :admin_manage_users
    can [:read, :create], Report
  end

  def load_manager user
    can :manage, :manage_divisions
    can [:read, :create], Report
    can :manage, Request
    can :manage, :approve_requests
    can :manage, :manage_groups
    can [:read, :destroy], :manage_members
    can [:read], :manage_reports
    can :manage, :manage_projects
  end

  def load_member user
    can [:read, :create], Report
    can :manage, Request
  end

  def load_leader user
    can [:read, :destroy], :manage_members
    can [:read], :manage_reports
    can :manage, :manage_projects
  end
end
