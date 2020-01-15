class Division < ApplicationRecord
  has_many :approval_requests, dependent: :destroy
  has_many :users, dependent: :destroy
  belongs_to :parent, class_name: Division.name, optional: true

  validates :name, presence: true,
             length: {maximum: Settings.divisions.name_max}
end
