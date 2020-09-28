# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'invalid edit information' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', email: 'hung123123@gmail.com',
                                              password: 'invalid', password_confirmation: 'invalid' } }
    assert_template 'users/edit'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  test 'valid edit information' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    email = 'hung123123@gmail.com'
    name = 'Hung'
    patch user_path(@user), params: { user: { name: name, email: email,
                                              password: 'Hung123456', password_confirmation: 'Hung123456' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.email, email
    assert_equal @user.name, name
  end
  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong other' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_redirected_to login_url
  end
  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
  end
end
