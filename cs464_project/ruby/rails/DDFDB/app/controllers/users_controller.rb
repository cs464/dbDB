class UsersController < ApplicationController
	def index
		@users = User.paginate(:page => params[:page], :per_page => 10)
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			redirect_to users_path
		else
			redirect_to new_user_path
		end
	end

	def show
		@user = User.find(params[:user])
	end

	def destroy
		@user = User.find(params[:user])
		@user.destroy
		redirect_to users_path
	end

	def confirm
	end
end