# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  skip_before_action :verify_authenticity_token, only: :github

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  def github
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

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
