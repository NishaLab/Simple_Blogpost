class ReactionsController < ApplicationController
  before_action :logged_in_user

  def create
    user_id = current_user.id
    micropost_id = params[:micropost]
    image_id = params[:image_id]
    react_count = Reaction.where(micropost_id: micropost_id, user_id: user_id).limit(1).count
    @react = Reaction.find_by(micropost_id: micropost_id, user_id: user_id, image_id: image_id) ||
            current_user.reactions.build(micropost_id: params[:micropost], image_id: params[:image_id])

    # if react exist -> destroy
    if @react.persisted?
      @react.destroy
      redirect_to request.referrer || root_url
    # if user already react to this post -> destroy other react -> save this react
    elsif react_count == 1
      Reaction.where(micropost_id: micropost_id, user_id: user_id).delete_all
      save(@react)
    # if not -> save this react
    else save(@react)     end
  end

  def save react
    if react.save
      flash[:success] = "React created successfully"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = "Failed to create react"
      render "static_pages/home"      
    end
  end

  def destroy; end
end
