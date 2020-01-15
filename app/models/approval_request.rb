class ApprovalRequest < ApplicationRecord
  enum status: {waiting: 0, approval: 1, rejected: 2}

  belongs_to :division
  belongs_to :request

  validates_associated :division, :request
end
