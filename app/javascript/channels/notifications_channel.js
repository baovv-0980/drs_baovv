import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data.layout)
    console.log(data.user_id)
    console.log(data.user_receiver)
    $('#notificationList').append(data.layout)
    $('#notification-counter').html(data.counter)
    if (Notification.permission === 'granted' && data.user_receiver == data.user_id) {
      var title = data.object.title +""
      var body = "Notification form " + data.name
      var options = { body: body }
      new Notification(title, options)
    }
  }
});
