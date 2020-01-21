class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(counter,notification,name)
    ActionCable.server.broadcast "notification_channel", counter: render_counter(counter), notification: render_notification(notification), object: notification, name: name
  end

  private

  def render_counter(counter)
    ApplicationController.renderer.render(partial: "notifications/counter", locals: { counter: counter })
  end

  def render_notification(notification)
    ApplicationController.renderer.render(partial: "notifications/notification", locals: { notification: notification })
  end
end
