class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast "chat_room_#{message.receiver.id}_channel",
                                 received_message: render_message(message),
                                 message: message, chat_window: render_chat_window(message)
  end

  def render_message message
    ApplicationController.renderer.render(partial: "shared/receiver", locals: { message: message })
  end

  def render_chat_window message
    data = {
      messages: Message.messages_between(message.sender.id,message.receiver.id),
      receiver_id: message.sender.id,
      sender_id: message.receiver.id,
      current_user: message.receiver
    }
    ApplicationController.renderer.render(partial: "messages/chat_form",
                                          locals: data )
  end
end
