class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! # Redirect unless user is logged in.

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    create_helper(@user, "User")
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    update_helper(@user, "User", user_params)
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    destroy_helper(@user, users_url, "User")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email_address, :is_admin, :comments)
    end
end
