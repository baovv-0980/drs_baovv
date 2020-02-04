class Report < ApplicationRecord
  PARAMS = %i(title plan actual next_plan issue).freeze

  belongs_to :user
  has_many :notifications, as: :object

  validates :title, presence: true,
            length: {maximum: Settings.reports.title_max,
                     minimum: Settings.reports.title_min}
  validates :plan, presence: true,
            length: {maximum: Settings.reports.text_max,
                     minimum: Settings.reports.text_min}
  validates :actual, presence: true,
            length: {maximum: Settings.reports.text_max,
                     minimum: Settings.reports.text_min}
  validates :next_plan, presence: true,
            length: {maximum: Settings.reports.text_max,
                     minimum: Settings.reports.text_min}

  scope :with_long_title, ->(search){where("users.name LIKE ?", "%#{search}%")}

  def self.search search
    if search.blank?
      all
    else
      with_long_title(search)
    end
  end
end
