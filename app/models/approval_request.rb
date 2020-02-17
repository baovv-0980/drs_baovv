class ApprovalRequest < ApplicationRecord
  enum status: {waiting: 0, approval: 1, rejected: 2}

  belongs_to :division
  belongs_to :request
  has_many :notifications, as: :object

  validates_associated :division, :request

  def self.request_with_date date_form, date_to
    if date_form.blank? && date_to.blank?
      all
    elsif date_form.blank? && date_to.present?
      where "created_at <= ?", date_to
    elsif date_form.present? && date_to.blank?
      where "created_at >= ?", date_form
    else
      where "created_at between ? and ?", date_form, date_to
    end
  end

end
