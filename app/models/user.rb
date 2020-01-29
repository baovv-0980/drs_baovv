class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email
  PARAMS = %i(name email birthday phone role division_id skill password password_confirmation).freeze

  enum role: {member: 0, manager: 1, admin: 2}

  belongs_to :division, optional: true
  has_many :reports, dependent: :destroy
  has_many :requests, dependent: :destroy

  has_many :notifications, class_name: Notification.name,
                           foreign_key: :receiver_id, dependent: :destroy
  has_many :sent_notifications, class_name: Notification.name,
                                foreign_key: :sender_id, dependent: :destroy

  has_many :senders, through: :sent_notifications, source: :sender
  has_many :receivers, through: :notifications, source: :receiver

  validates :name, presence: true, length: {maximum: Settings.users.name_max}
  validates :email, presence: true, length: {maximum: Settings.users.email_max},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :birthday, presence: true
  validates :phone, presence: true
  validates :skill, presence: true
  validates :skill, presence: true
  before_save :downcase_email

  has_secure_password


  def self.search(type,search)
    if search.blank?
      all
    else
      where(["#{type} LIKE ?","%#{search}%"])
    end
  end

  def self.add(type,search)
    if search.blank?
      where(division_id: nil)
    else
      where(division_id: nil).where("#{type} LIKE ?","%#{search}%")
    end
  end

  def self.all_user(type,search)
    if search.blank?
      all
    else
      where("#{type} LIKE ?","%#{search}%")
    end
  end

  def self.search(type,search)
    if search
      where(["#{type} LIKE ?","%#{search}%"])
    else
      all
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
