# frozen_string_literal: true

# static page controller
class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
  end

  def about; end

  def contact; end

  def help; end
end
