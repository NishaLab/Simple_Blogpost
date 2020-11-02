# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.send_reset_password_instructions
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render "new"
    end
  end

  def update
    if params[:user][:password].empty? || params[:user][:password_confirmation].empty?
      @user.errors.add(:password, "can't be empty")
      @user.errors.add(:password_confirmation, "can't be empty")
      render "edit"
    elsif @user.update(user_params)
      @user.forget
      @user.update_attribute(:reset_digest, nil)
      reset_session
      log_in(@user)
      flash[:succes] = "Password has been changed"
      redirect_to @user
    else
      render "edit"
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.activated && @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    flash[:danger] = "Password reset has expired." if @user.password_reset_expired?
    return redirect_to new_password_reset_url if @user.password_reset_expired?
  end
end
