module ProfilesHelper
  def gender_select
    User.genders.keys.map{|i| i}
  end

  def workspace_select
    User.workspaces.keys.map{|i| i}
  end

  def position_select
    User.positions.keys.map{|i| i}
  end

  def role_division_select
    User.roles.keys.map{|i| i}
  end

  def division_type_select
    Division.all.map{|i| i}
  end

  def staff_type_select
    User.staff_types.keys.map{|i| i}
  end

  def nationality_select
    User.nationalities.keys.map{|i| i}
  end
end
