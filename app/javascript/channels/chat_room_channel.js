import consumer from "./consumer";

consumer.subscriptions.create("ChatRoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data.message)
    var $window, $chat_window;
    $window = $("#chats");
    $chat_window = $(`#chat_window_${data.message.sender_id}`);
    console.log($window)
    console.log($chat_window.length)
    if ($chat_window.length == 0) {
      $window.before(data.chat_window);
    } else {
      $chat_window.before(data.received_message);
    }
  },
});
