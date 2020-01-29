module AdminManageUsersHelper
  def division_type_select
    division = Division.all.map{|i| i}
  end
  def role_type_select
    User.roles.keys.map{|i| i}
  end
end
