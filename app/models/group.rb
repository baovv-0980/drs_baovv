class Group < ApplicationRecord
  PARAMS = %i(name description division_id).freeze

  belongs_to :division
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

  validates :description, presence: true
  validates :name, presence: true, uniqueness: true,
             length: {maximum: Settings.divisions.name_max}
  scope :search_group, ->(search) {where "name LIKE ? OR id LIKE ?","%#{search}%", "%#{search}%"}
end
