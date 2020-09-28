# frozen_string_literal: true

class AccountActivationController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user&.authenticated?(:activation, params[:id]) && !user.activated?
      user.activate
      log_in user
      flash[:succes] = 'Account Activated'
      redirect_to user
    else
      flash[:danger] = 'Invalid Activation Link'
      redirect_to root_url
    end
  end
end
