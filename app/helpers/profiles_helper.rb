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
