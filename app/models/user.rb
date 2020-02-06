class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email
  PARAMS = %i(name email birthday phone role division_id skill password password_confirmation).freeze

  PARAMS_PROFILE = %i(name birthday phone skill gender).freeze
  PARAMS_PASSWORD = %i(password).freeze

  attr_accessor :remember_token

  enum role: {Member: 0, Manager: 1, Admin: 2}
  enum staff_type: {EDU: 0, Intern: 1, Fresher: 2, Developer: 3}
  enum nationality: {Vietnam: 0, Japan: 1}
  enum workspace: {Hanoi: 0, DaNang: 1}
  enum gender: {Male: 0, Female: 1}
  enum position: {DEV: 0, QA: 1, HR: 2}
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
  validates :division_id, presence: true
  before_save :downcase_email

  has_secure_password

  scope :search_user, ->(search) {where "name LIKE ? OR id LIKE ? OR email LIKE ?","%#{search}%", "%#{search}%", "%#{search}%"}

  scope :division_empty, -> {where division_id: nil}

  def self.search type, search
    if search.blank?
      all
    else
      where(["#{type} LIKE ?", "%#{search}%"])
    end
  end

  def self.add type, search
    if search.blank?
      where(division_id: nil)
    else
      where(division_id: nil).where("#{type} LIKE ?", "%#{search}%")
    end
  end

  def self.search type, search
    if search
      where(["#{type} LIKE ?", "%#{search}%"])
    else
      all
    end
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    email.downcase!
  end
end
