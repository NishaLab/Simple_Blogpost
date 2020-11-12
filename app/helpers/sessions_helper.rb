# frozen_string_literal: true

module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies.encrypted[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  def current_user? user
    user && user == current_user
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent.encrypted[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def daily_report
    slack = DailyReportSlackService.new
    @current_user_count   = User.all.count
    @new_user_count       = User.where("created_at > ?", 1.day.ago).count
    @new_post             = Micropost.new_posts
    @new_post_count       = Micropost.new_posts.count
    @new_react            = Reaction.new_reactions
    @interact_user_count  = @new_post.pluck[:user_id] + @new_react.pluck(:user_id)
    @interact_user_count  = @interact_user_count.uniq.count
    slack.report(@current_user_count, @new_post_count, @new_post_count, @interact_user_count).deliver
  rescue StandardError => e
    error_report("Exception at #{__method__} " + e.message)
  end

  def error_report message
    slack = DailyReportSlackService.new
    slack.error_report(message).deliver
  end
end
