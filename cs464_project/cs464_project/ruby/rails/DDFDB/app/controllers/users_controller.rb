class UsersController < ApplicationController
  # displays table (returns HTML, manually formatted by CSS API)
  def index
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  # instantiates user object
  def new
    @user = User.new
  end

  # inserts new tuple into DB
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path
    else
      redirect_to new_user_path
    end
  end

  # selects/displays individual tuple
  def show
    @user = User.find(params[:user])
  end

  # deletes tuple from DB
  def destroy
    @user = User.find(params[:user])
    @user.destroy
    redirect_to users_path
  end
end

