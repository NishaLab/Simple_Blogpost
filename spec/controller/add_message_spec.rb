require "rails_helper"

RSpec.describe MessagesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }

  let(:message_params) {
    {
      sender_id: user.id,
      receiver_id: user2.id,
      message: {
        content: "blah blah blah"
      },
      format: "js"
    }
  }
  before(:each) do
    log_in user
  end

  it "should add message with valid information" do
    expect { post :create, params: message_params }.to(change(Message, :count).by(1)) &&
      have_broadcasted_to("chat_room_#{Message.last.receiver.id}_channel").with(
        message: Message.last,
        received_message: ApplicationController.renderer.render(
          partial: "shared/receiver",
          locals: { message: Message.last }
        ),
        chat_window: ApplicationController.renderer.render(
          partial: "messages/chat_form",
          locals: { messages: Message.messages_between(Message.last.sender_id ,Message.last.receiver.id),
                    receiver_id: Message.last.sender.id,
                    sender_id: Message.last.receiver.id,
                    current_user: user }
        )
      )
  end
end
