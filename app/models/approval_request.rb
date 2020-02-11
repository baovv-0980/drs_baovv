class ApprovalRequest < ApplicationRecord
  enum status: {waiting: 0, approval: 1, rejected: 2}

  belongs_to :division
  belongs_to :request
  has_many :notifications, as: :object

  validates_associated :division, :request

  scope :range_date, ->(params) {where "created_at BETWEEN ? AND ?", Date.parse(params.days.ago.to_date.to_s), Date.parse(Date.today.tomorrow.to_s)}
  scope :search_request, -> (search) {where "users.id LIKE ? or users.name LIKE ?", "%#{search}%", "%#{search}%"}
  scope :search_type, -> (type) {where(status: type)}
end
