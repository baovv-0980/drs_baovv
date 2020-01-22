class ApprovalRequestSearch
  attr_reader :date_form, :date_to

  def initialize params
    params ||= {}
    @date_form = parsed_date(params[:date_form], 7.days.ago.to_date.to_s)
    @date_to = parsed_date(params[:date_to], Date.today.tomorrow.to_s)
  end

  def scope(request)
    request.where("created_at BETWEEN ? AND ?", @date_form, @date_to)
  end

  private

  def parsed_date(date_string, default)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    default
  end
end
