class Request < ApplicationRecord
  enum status: {waiting: 0, approval: 1, rejected: 2}
  enum type: {lated: 0, leaved: 1}

  belongs_to :user
  has_many :notifications, as: :object
  has_many :approval_requests

  validates :time, presence: true
  validates :reason, presence: true,
                     length: {maximum: Settings.requests.reason_max,
                              minimum: Settings.requests.reason_min}
end
