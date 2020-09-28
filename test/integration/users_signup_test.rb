# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get sign_up_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information with account activation' do
    get sign_up_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'test',
                                         email: 'hungtest@gmail.com',
                                         password: 'Hung123456',
                                         password_confirmation: 'Hung123456' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not logged_in?
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
  end
end
