class Notification < ApplicationRecord
  after_create :send_notification

  def send_notification
    NotificationBroadcastJob.perform_now(ApplicationController.helpers.current_user.notifications.count, ApplicationController.helpers.current_user.id, self, self.sender.name)
  end

  enum status: {waiting: 0, approval: 1, rejected: 2}

  belongs_to :sender, class_name: User.name, foreign_key: :sender_id
  belongs_to :receiver, class_name: User.name, foreign_key: :receiver_id
  belongs_to :object, polymorphic: true

  validates :title, presence: true,
            length: {maximum: Settings.notifications.title_max,
                     minimum: Settings.notifications.title_min}

  validates :object_id, presence: true

  validates_associated :sender, :receiver
end
