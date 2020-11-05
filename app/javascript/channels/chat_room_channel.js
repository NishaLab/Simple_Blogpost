import consumer from "./consumer";
document.addEventListener("turbolinks:load", () => {
  consumer.subscriptions.create("ChatRoomChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      var $window, $chat_window, $chat_content;
      $window = $("#chats");
      $chat_window = $(`#chat_window_${data.message.sender_id}`);
      if ($chat_window.length == 0) {
        $window.append(data.chat_window);
      } else {
        $chat_content = $(`#chat_content_${data.message.sender_id}`);
        $chat_content.append(data.received_message);
      }
    },
  });
});
