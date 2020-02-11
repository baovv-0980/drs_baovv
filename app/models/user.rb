class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_EMAIL_REGEX = Settings.email
  PARAMS = %i(name email birthday phone role division_id skill password password_confirmation).freeze

  PARAMS_PROFILE = %i(name birthday phone skill gender).freeze
  PARAMS_PASSWORD = %i(password).freeze

  enum role: {member: 0, manager: 1, admin: 2}
  enum staff_type: {EDU: 0, Intern: 1, Fresher: 2, Developer: 3}
  enum nationality: {Vietnam: 0, Japan: 1}
  enum workspace: {Hanoi: 0, DaNang: 1}
  enum gender: {Male: 0, Female: 1}
  enum position: {DEV: 0, QA: 1, HR: 2}

  belongs_to :division, optional: true

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :physicians, through: :appointments
  has_many :reports, dependent: :destroy
  has_many :requests, dependent: :destroy

  has_many :notifications, class_name: Notification.name,
                           foreign_key: :receiver_id, dependent: :destroy
  has_many :sent_notifications, class_name: Notification.name,
                                foreign_key: :sender_id, dependent: :destroy

  has_many :senders, through: :sent_notifications, source: :sender
  has_many :receivers, through: :notifications, source: :receiver

  validates :name, presence: true, length: {maximum: Settings.users.name_max}
  validates :birthday, presence: true
  validates :phone, presence: true
  validates :skill, presence: true
  validates :division_id, presence: true
  before_save :downcase_email

  scope :division_empty, -> {where division_id: nil}

  private

  def downcase_email
    email.downcase!
  end
end
