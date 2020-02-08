class Report < ApplicationRecord
  PARAMS = %i(title plan actual next_plan issue group_id).freeze

  belongs_to :user
  belongs_to :group
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

  scope :search_reports, ->(search){where("title LIKE ?", "%#{search}%")}
  scope :range_date, ->(params) {where "created_at BETWEEN ? AND ?", Date.parse(params.days.ago.to_date.to_s), Date.parse(Date.today.tomorrow.to_s)}
end
