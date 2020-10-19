import { logger } from "@rails/actioncable";
import consumer from "./consumer";

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $("#notification-menu").prepend("" + data.notification);
    return this.update_counter();
  },
  update_counter() {
    var $counter, val;
    $counter = $("#notification-counter");
    val = parseInt($counter.text());
    val++;
    return $counter.text(val)
  },
});
