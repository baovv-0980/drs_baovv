class Division < ApplicationRecord
  PARAMS = %i(name parent_id parent_path).freeze

  has_many :approval_requests, dependent: :destroy
  has_many :users, dependent: :destroy
  belongs_to :parent, class_name: Division.name, optional: true

  validates :name, presence: true,
             length: {maximum: Settings.divisions.name_max}

  def self.all_division(type,search)
    if search.blank?
      all
    else
      where("#{type} LIKE ?","%#{search}%")
    end
  end

end
