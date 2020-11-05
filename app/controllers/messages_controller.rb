class MessagesController < ApplicationController
  def create
    @message = Message.new(sender_id: params[:sender_id], receiver_id: params[:receiver_id],
                           content: params[:message][:content])
    if @message.save
      flash[:sucess] = "Send message successfully"
    else
      flash[:danger] = "Send message fail"
    end
  end
end
