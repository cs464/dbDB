class PursuingsController < ApplicationController
	def index
		@pursuings = Pursuing.paginate(:page => params[:page], :per_page => 10)
	end

	def new
		@pursuing = Pursuing.new
	end

	def create
		@pursuing = Pursuing.new(params[:pursuing])
		if @pursuing.save
			redirect_to pursuings_path
		else
			redirect_to new_pursuings_path
		end
	end

	def show
		@pursuing = Pursuing.find(params[:username])
	end
end
