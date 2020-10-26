# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.valid_for_authentication? && @user&.valid_password?(params[:session][:password])
      if @user.activated?
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
end
