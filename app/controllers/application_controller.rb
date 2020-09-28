# frozen_string_literal: true

# application controller
class ApplicationController < ActionController::Base
  include SessionsHelper
  def hello
    render html: 'Hello World'
  end

  def goodbye
    render html: "ZCZXC::!@\#!$!@\#%@!\#$"
  end
end
