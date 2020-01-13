class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email

  enum role: {member: 0, manager: 1, admin: 2}

  belongs_to :division
  has_many :reports, dependent: :destroy
  has_many :requests, dependent: :destroy

  has_many :notifications, class_name: Notification.name,
                           foreign_key: :receiver_id, dependent: :destroy
  has_many :sent_notifications, class_name: Notification.name,
                                foreign_key: :sender_id, dependent: :destroy

  has_many :senders, through: :sent_notifications, source: :sender
  has_many :receivers, through: :notifications, source: :receiver

  validates :name, presence: true, length: {maximum: Settings.user.name_max}
  validates :email, presence: true, length: {maximum: Settings.email_max},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :birthday, presence: true
  validates :phone, presence: true

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
