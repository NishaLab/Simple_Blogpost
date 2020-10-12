# frozen_string_literal: true

# micopost controller
class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  # GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.all
    respond_to do |format|
      format.html
      file_name = "export_micropost_"+ Time.zone.now.to_s
      format.xlsx {
        response.headers["Content-Disposition"] = "attachment; filename=#{file_name}.xlsx"
      }
    end
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show; end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit; end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    @micropost.parent_id = params[:parent_id]
    if @micropost.save
      flash[:succes] = I18n.t "comment.success"
      respond_to do |format|
        format.html
        format.js
      end
    else
      flash[:danger] = I18n.t "comment.failed"
      redirect_to request.referer || root_url
    end
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: "Micropost was successfully updated." }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    Micropost.find_by(id: params[:id]).destroy
    flash[:succes] = "Micropost was succesfully deleted"
    if request.referer.nil? || request.referer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referer
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
