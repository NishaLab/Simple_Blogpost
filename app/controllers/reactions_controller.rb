class ReactionsController < ApplicationController
  before_action :logged_in_user

  def create
    micropost_id = params[:micropost]
    image_id = params[:image_id]
    # if user already reacted to this post with other react -> destroy other react
    Reaction.where(micropost_id: micropost_id, user_id: current_user.id).where.not(image_id: params[:image_id]).destroy_all
    @react = current_user.reactions.build(micropost_id: params[:micropost], image_id: params[:image_id])
    # if react exist -> destroy
    if Reaction.exists?(user_id: current_user.id, micropost_id: params[:micropost])
      Reaction.find_by(user_id: current_user.id, micropost_id: params[:micropost]).destroy
      redirect_to request.referer || root_url
    # if not -> save this react
    else save(@react) end
  end

  def save react
    if react.save
      flash[:success] = "React created successfully"
      redirect_to request.referer || root_url
    else
      flash[:danger] = "Failed to create react"
      render "static_pages/home"
    end
  end

  def destroy; end
end
