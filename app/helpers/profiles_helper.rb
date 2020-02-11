module ProfilesHelper
  DATE = [["Today",1], ["Yesterday",2], ["Last 7 Days",7], ["Last 30 Days",30]]

  def gender_select
    User.genders.keys.map{|i| i}
  end

  def date_choose params
    params = DATE[0][0] if params.blank?
    DATE.collect{|i| return i[1] if i[0] == params}
  end

  def date_select
    DATE.map{|i| i }
  end

  def status_request_select
    Request.statuses.keys.map{|i| "<option>#{i}</option>"}
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

  def division_edit_select(division)
    Division.all.select{|i| i if(i != division)}
  end

  def division_group_select
    Division.all.map{|i| i}
  end

  def division_childrents_select
    @division = []
    dq(current_division)
    @division
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

  def group_select
     Group.all.map{|i| i}
  end

  def role_group_select
    UserGroup.roles.keys.map{|i| i}
  end

  def my_group_select
    current_user.groups.map{|i| i}
  end

  # ARRAY = []
  # def index
  #   dequy(current_division.children.ids)
  # end

  # def dequy param
  #   param.each do |i|
  #     division = Division.find(i);
  #     ARRAY.push(division)
  #     if division.blank?
  #       return ARRAY
  #     else
  #       dequy(division.children.ids)
  #     end
  #   end
  # end

  def staff_type_select
    User.staff_types.keys.map{|i| i}
  end

  def nationality_select
    User.nationalities.keys.map{|i| i}
  end

  def request_type_select
    Request.request_types.keys.map{|i| i}
  end
end
