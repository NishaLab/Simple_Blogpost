class ReactionsController < ApplicationController
  before_action :logged_in_user

  def create
    # if user already reacted to this post with other react -> destroy other react
    Reaction.where(micropost_id: params[:micropost],
                   user_id: current_user.id).where.not(image_id: params[:image_id]).destroy_all
    @react = current_user.reactions.build(micropost_id: params[:micropost], image_id: params[:image_id])
    @span_id = "#{params[:micropost]}-react-count-#{params[:image_id]}"
    # if react exist -> destroy
    respond_to do |format|
      if Reaction.exists?(user_id: current_user.id, micropost_id: params[:micropost])
        Reaction.find_by(user_id: current_user.id, micropost_id: params[:micropost]).destroy
        # if not -> save this react

      elsif @react.save
        flash[:success] = I18n.t "React created successfully"
      else
        flash[:danger] = I18n.t "Failed to create react"
      end
      format.html 
      format.js
    end
  end

  def destroy; end
end
