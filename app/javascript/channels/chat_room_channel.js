import consumer from "./consumer";

consumer.subscriptions.create("ChatRoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $chat_window = $(`#chat_window_${data.reaction.receiver_id}`);
    if ($chat_window.length==0) {
      $chat_window.html(data.chat_window)
      $chat_window.before(data.received_message)

    }
  },
});
