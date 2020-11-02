class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    @message = Message.new(sender_id: params[:sender_id], receiver_id: params[:receiver_id], content: params[:content])
    if @message.save
      flash[:sucess] = "Send message successfully"
    else
      flash[:danger] = "Send message fail"
    end
  end
end
