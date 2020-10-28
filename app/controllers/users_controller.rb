# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: %i(show edit update destroy read_notification)
  before_action :logged_in_user, only: %i(index show edit update following followers)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  # GET /users
  # GET /users.json
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to(root_url) && return unless @user.activated?
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "users/new"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      flash.now[:success] = "Edit Successed"
      redirect_to @user
    else
      flash.now[:danger] = "Edit Failed"
      render "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find_by(id: params[:id]).destroy
    flash.now[:succes] = "User was succesfully deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  def export
    csv = ExportCsvService.new
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      zos.put_next_entry "export_posts.csv"
      zos.print csv.export_posts params[:id]
      zos.put_next_entry "export_followers.csv"
      zos.print csv.export_followers params[:id]
      zos.put_next_entry "export_followings.csv"
      zos.print csv.export_followings params[:id]
    end
    compressed_filestream.rewind
    send_data compressed_filestream.read, filename: "export_for_user_#{params[:id]}_#{Time.zone.now}.zip"
  end

  def read_notification
    @user.update(read_notification: true)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to login_url unless (current_user.has_role? :admin) || current_user?(@user)
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :activated, :activated_at)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
