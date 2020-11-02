# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   binding.pry
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    @user = User.with_reset_password_token(params[:user][:reset_password_token])
    if params[:user][:password].empty? || params[:user][:password_confirmation].empty?
      @user.errors.add(:password, "can't be empty")
      @user.errors.add(:password_confirmation, "can't be empty")
      render "devise/passwords/edit"
    elsif @user.reset_password(params[:user][:password], params[:user][:password_confirmation])
      @user.forget
      reset_session
      flash[:succes] = "Password has been changed"
      redirect_to root_url
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
