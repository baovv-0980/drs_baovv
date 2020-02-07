class Request < ApplicationRecord
  PARAMS = %i(request_type time_from time_to reason).freeze

  enum status: {waiting: 0, approval: 1, rejected: 2, forwarded: 3}
  enum request_type: {in_lated: 0, leave_early: 1, forgot_card: 2}

  belongs_to :user
  has_many :notifications, as: :object
  has_many :approval_requests, dependent: :destroy

  validates :time_from, presence: true
  validates :time_to, presence: true
  validates :reason, presence: true,
                     length: {maximum: Settings.requests.reason_max,
                              minimum: Settings.requests.reason_min}

  scope :search_request, -> (search) {where "requests.id LIKE ? or users.name LIKE ?", "%#{search}%", "%#{search}%"}
  scope :search_type, -> (type) {where(status: type)}
end
