# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.valid_for_authentication? && @user&.valid_password?(params[:session][:password])
      if @user.confirmed?
        forwarding_url = session[:forwarding_url]
        reset_session
        log_in(@user)
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        redirect_to forwarding_url || root_url
      else
        message = "Account not activated\n"
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    elsif @user.nil?
      flash[:danger] = "Invalid email/password combination"
      redirect_to root_url
    else
      if @user.access_locked?
        flash.now[:danger] = "Account locked"
        return render "new"
      end
      flash.now[:danger] = "Invalid email/password combination"
      @user.increment_failed_attempts
      flash.now[:danger] = "Last attempt" if @user.send(:last_attempt?)
      if @user.send(:attempts_exceeded?)
        @user.lock_access!
        @user.send_unlock_instructions
      end
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def omniauth
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted? || @user.save
      forwarding_url = session[:forwarding_url]
      reset_session
      log_in(@user)
      redirect_to forwarding_url || root_url
      flash[:succes] = "Login successful"
    else
      flash[:danger] = @user.errors.full_messages.join("\n")
      redirect_to login_path
    end
  end

  def daily_report
    slack = DailyReportSlackService.new
    @current_user_count   = User.all.count
    @new_user_count       = User.where("created_at > ?", 1.day.ago).count
    @new_post             = Micropost.new_posts
    @new_post_count       = Micropost.new_posts.count
    @new_react            = Reaction.new_reactions
    @interact_user_count  = @new_post.pluck(:user_id) + @new_react.pluck(:user_id)
    @interact_user_count  = @interact_user_count.uniq.count
    slack.daily_report(@current_user_count, @new_post_count, @new_post_count, @interact_user_count).deliver
  rescue StandardError => e
    error_report("Exception at #{__method__} " + e.message)
  end

  def error_report message
    slack = DailyReportSlackService.new
    slack.error_report(message).deliver
  end
end
