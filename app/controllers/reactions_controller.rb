class ReactionsController < ApplicationController
  load_and_authorize_resource
  before_action :logged_in_user

  def create
    # if user already reacted to this post with other react -> destroy other react
    Reaction.where(micropost_id: params[:micropost],
                   user_id: current_user.id).where.not(image_id: params[:image_id]).destroy_all
    @react = current_user.reactions.build(micropost_id: params[:micropost], image_id: params[:image_id])
    @span_id = "#{params[:micropost]}-react-count-#{params[:image_id]}"
    # if react exist -> destroy
    reaction = Reaction.find_by(user_id: current_user.id, micropost_id: params[:micropost])
    respond_to do |format|
      if reaction.present?
        NotificationBroadcastJob.perform_later(reaction, true)
        reaction.destroy
        # if not -> save this react

      elsif @react.save
        NotificationMailer.new_notification(@react).deliver_now
        @react.micropost.user.update(read_notification: false)
        flash[:success] = I18n.t "react.success"
      else
        flash[:danger] = I18n.t "react.failed"
      end
      format.html
      format.js
    end
  end

  def update
    @react = Reaction.find(params[:id])
    @react.update(is_read: true)
  end

  def destroy; end
end
