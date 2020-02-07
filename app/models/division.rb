class Division < ApplicationRecord
  PARAMS = %i(name parent_id parent_path).freeze

  has_many :approval_requests, dependent: :destroy
  has_many :users, dependent: :destroy

  has_many :reports, through: :users
  belongs_to :parent, class_name: Division.name, optional: true

  validates :name, presence: true,
             length: {maximum: Settings.divisions.name_max}

  scope :search_division, ->(search) {where "name LIKE ? OR id LIKE ?","%#{search}%", "%#{search}%"}
end
