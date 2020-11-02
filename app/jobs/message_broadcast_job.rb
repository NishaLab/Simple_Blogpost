class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast "chat_room_#{message.receiver}_channel",
                                 received_message: render_message(message),
                                 message: message, chat_window: render_chat_window(message)
  end

  def render_message message
    ApplicationController.renderer.render(partial: "shared/receiver", locals: { message: message })
  end

  def render_chat_window message
    ApplicationController.renderer.render(partial: "message/chat_form",
                                          locals: { messages: Message.current_user_messages(message.receiver.id),
                                                    receiver_id: message.sender.id,
                                                    sender_id: message.receiver.id })
  end
end
