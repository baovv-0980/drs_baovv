class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform room, name
    ActionCable.server.broadcast "room#{room.receiver_id}", notifi: room, counter: render_counter(room.receiver.notifications.count), layout: render_notification(room), name_sender: name
  end

  private

  def render_counter counter
    ApplicationController.renderer.render(partial: "notifications/counter", locals: {counter: counter})
  end

  def render_notification notification
    ApplicationController.renderer.render(partial: "notifications/notification", locals: {notification: notification})
  end
end
