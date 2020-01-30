import consumer from "./consumer"
$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create("NotificationsChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data.layout)
      // Called when there's incoming data on the websocket for this channel
      $("#notification-list").prepend(data.layout)
      $("#notification-counter").html(data.counter)
      if (Notification.permission === 'granted') {
        var title = data.notifi.title +""
        var body = "Notification form " + data.name_sender
        var options = { body: body }
        new Notification(title, options)
      }
    }
  });
})
