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
    var $counter, val;
    $counter = $("#notification-counter");
    val = parseInt($counter.text());
    if(data.destroy == true){
      $(`#notification-${data.reaction.id}`).html("");
      val -= 1;
    }
    else{
      $("#notification-menu").prepend("" + data.notification);
      val += 1;
    }
    return $counter.text(val)
  },

});
