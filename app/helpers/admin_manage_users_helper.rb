module AdminManageUsersHelper
  def division_type_select
    division = Division.all.map{|i| {id: i.id, values: i.name}}
    division.unshift({id: nil, values: "NULL"})
  end
  def role_type_select
    User.roles.keys.map{|i| {id: i, values: i}}
  end
end
