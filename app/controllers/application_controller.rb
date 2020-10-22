# frozen_string_literal: true

# application controller
class ApplicationController < ActionController::Base
  include SessionsHelper
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to request.referer || root_url, :alert => exception.message
  end
  def hello
    render html: "Hello World"
  end

  def goodbye
    render html: "ZCZXC::!@\#!$!@\#%@!\#$"
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      store_location
    end
    return redirect_to login_url unless logged_in?
  end
end
